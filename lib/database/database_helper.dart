import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    _database = await _initDB('budget_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    print("Database path: $path");

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print("Creating database with version $version");
    
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        is_admin INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        user_id TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    // Create default super admin account
    await db.insert('users', {
      'id': 'admin_001',
      'email': 'admin@budgettracker.com',
      'password': 'Admin@123',
      'is_admin': 1,
    });
    
    print("Super admin created!");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from $oldVersion to $newVersion");
    
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN user_id TEXT');
    }
    
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE users ADD COLUMN is_admin INTEGER DEFAULT 0');
        // Create default super admin if not exists
        final existingAdmin = await db.query('users', where: 'email = ?', whereArgs: ['admin@budgettracker.com']);
        if (existingAdmin.isEmpty) {
          await db.insert('users', {
            'id': 'admin_001',
            'email': 'admin@budgettracker.com',
            'password': 'Admin@123',
            'is_admin': 1,
          });
          print("Super admin added during upgrade!");
        }
      } catch (e) {
        print("Error adding is_admin column: $e");
      }
    }
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTransactions(String userId) async {
    final db = await database;
    await db.delete('transactions', where: 'user_id = ?', whereArgs: [userId]);
  }
  
  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('transactions', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
  
  Future<void> makeAdmin(String userId) async {
    final db = await database;
    await db.update('users', {'is_admin': 1}, where: 'id = ?', whereArgs: [userId]);
  }
  
  Future<void> removeAdmin(String userId) async {
    final db = await database;
    await db.update('users', {'is_admin': 0}, where: 'id = ?', whereArgs: [userId]);
  }
}
