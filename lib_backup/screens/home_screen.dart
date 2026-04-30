import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';
import 'add_transaction_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    if (auth.isLoggedIn) {
      print('HomeScreen: Loading transactions for user ${auth.userId}');
      await transactionProvider.loadTransactions(auth.userId);
    }
  }

  String _formatAmount(double amount, String symbol) {
    return "$symbol${amount.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Tracker"),
        actions: [
          // Currency selector with saved value
          PopupMenuButton<String>(
            icon: Text(currencyProvider.currencySymbol, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onSelected: (String value) async {
              await currencyProvider.setCurrency(value);
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              final currencies = currencyProvider.getAvailableCurrencies();
              return currencies.map((currency) {
                return PopupMenuItem<String>(
                  value: currency["symbol"],
                  child: Row(
                    children: [
                      Text(currency["symbol"]!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Text(currency["name"]!),
                      if (currencyProvider.currencySymbol == currency["symbol"])
                        const Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Refreshed!")),
              );
            },
          ),
          // Dark/Light mode toggle
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: transactionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          "Balance",
                          _formatAmount(transactionProvider.balance, currencyProvider.currencySymbol),
                          transactionProvider.balance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          "Income",
                          _formatAmount(transactionProvider.totalIncome, currencyProvider.currencySymbol),
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          "Expense",
                          _formatAmount(transactionProvider.totalExpense, currencyProvider.currencySymbol),
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: transactionProvider.transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                "No transactions yet",
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Tap + button to add",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _loadData(),
                                child: const Text("Refresh"),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactionProvider.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionProvider.transactions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: transaction.type == "income"
                                      ? Colors.green
                                      : Colors.red,
                                  child: Icon(
                                    transaction.type == "income"
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(transaction.title),
                                subtitle: Text(
                                  "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                                ),
                                trailing: Text(
                                  "${transaction.type == "income" ? "+" : "-"}${_formatAmount(transaction.amount, currencyProvider.currencySymbol)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: transaction.type == "income"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                onLongPress: () {
                                  _showDeleteDialog(context, transaction.id!, auth.userId);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(
                userId: auth.userId,
                currencySymbol: currencyProvider.currencySymbol,
              ),
            ),
          );
          await _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int transactionId, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final transactionProvider = Provider.of<TransactionProvider>(
                context,
                listen: false,
              );
              await transactionProvider.deleteTransaction(transactionId, userId);
              await _loadData();
              if (context.mounted) {
                Navigator.pop(ctx);
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
