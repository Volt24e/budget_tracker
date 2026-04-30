import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<User> _users = [];
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAdminAndLoad();
  }

  Future<void> _checkAdminAndLoad() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // Security check - only admins can access
    if (!auth.isAdmin) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Access denied. Admin only!")),
        );
      }
      return;
    }
    
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final db = await DatabaseHelper.instance.database;
      
      // Get all users - simple query without complex conditions
      final usersList = await db.query('users');
      _users = usersList.map((map) => User.fromMap(map)).toList();
      
      // Get all transactions with user emails
      final transactionsList = await db.rawQuery('''
        SELECT t.*, u.email 
        FROM transactions t 
        JOIN users u ON t.user_id = u.id
        ORDER BY t.date DESC
      ''');
      _transactions = transactionsList;
      
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    // Extra security in build
    if (!auth.isAdmin) {
      return const Scaffold(
        body: Center(child: Text("Access Denied", style: TextStyle(fontSize: 24))),
      );
    }
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: "Refresh",
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Users", icon: Icon(Icons.people)),
              Tab(text: "All Transactions", icon: Icon(Icons.receipt)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text("Error: $_errorMessage"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : TabBarView(
                    children: [
                      _buildUsersTab(),
                      _buildTransactionsTab(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildUsersTab() {
    if (_users.isEmpty) {
      return const Center(child: Text("No users found"));
    }
    
    final currentUserId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
    
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        final isCurrentUser = user.id == currentUserId;
        final isSuperAdmin = user.email == "admin@budgettracker.com";
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: user.isAdmin ? Colors.green : Colors.blue,
                      child: Text(
                        user.email[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (user.isAdmin)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "ADMIN",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              if (isCurrentUser)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "YOU",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Delete button (can't delete super admin or yourself)
                    if (!isSuperAdmin && !isCurrentUser)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user),
                        tooltip: "Delete User",
                      ),
                    if (!isSuperAdmin && !isCurrentUser && !user.isAdmin)
                      IconButton(
                        icon: const Icon(Icons.admin_panel_settings, color: Colors.green),
                        onPressed: () => _makeAdmin(user),
                        tooltip: "Make Admin",
                      ),
                    if (!isSuperAdmin && !isCurrentUser && user.isAdmin)
                      IconButton(
                        icon: const Icon(Icons.person_remove, color: Colors.orange),
                        onPressed: () => _removeAdmin(user),
                        tooltip: "Remove Admin",
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("User ID: ${user.id}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    if (_transactions.isEmpty) {
      return const Center(child: Text("No transactions found"));
    }
    
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(
              transaction['type'] == 'income' 
                  ? Icons.trending_up 
                  : Icons.trending_down,
              color: transaction['type'] == 'income' 
                  ? Colors.green 
                  : Colors.red,
            ),
            title: Text(transaction['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User: ${transaction['email']}"),
                Text("Amount: \$${transaction['amount'].toStringAsFixed(2)}"),
                Text("Date: ${DateTime.parse(transaction['date']).day}/${DateTime.parse(transaction['date']).month}/${DateTime.parse(transaction['date']).year}"),
              ],
            ),
            trailing: Text(
              "${transaction['type'] == 'income' ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _makeAdmin(User user) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Make Admin"),
        content: Text("Make ${user.email} an admin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final db = await DatabaseHelper.instance.database;
                await db.update('users', {'is_admin': 1}, where: 'id = ?', whereArgs: [user.id]);
                await _loadData();
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${user.email} is now an admin!")),
                  );
                }
              } catch (e) {
                print("Error making admin: $e");
              }
            },
            child: const Text("Yes", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<void> _removeAdmin(User user) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Admin"),
        content: Text("Remove admin privileges from ${user.email}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final db = await DatabaseHelper.instance.database;
                await db.update('users', {'is_admin': 0}, where: 'id = ?', whereArgs: [user.id]);
                await _loadData();
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Admin rights removed from ${user.email}")),
                  );
                }
              } catch (e) {
                print("Error removing admin: $e");
              }
            },
            child: const Text("Yes", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(User user) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Are you sure you want to delete ${user.email}?\nThis will also delete ALL their transactions!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final db = await DatabaseHelper.instance.database;
                await db.delete('transactions', where: 'user_id = ?', whereArgs: [user.id]);
                await db.delete('users', where: 'id = ?', whereArgs: [user.id]);
                await _loadData();
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Deleted user: ${user.email}")),
                  );
                }
              } catch (e) {
                print("Error deleting user: $e");
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
