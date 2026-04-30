import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../supabase_config.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalIncome {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;

  Future<void> loadTransactions(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('=== LOADING TRANSACTIONS ===');
      print('User ID: $userId');
      
      final response = await SupabaseConfig.client
          .from('transactions')
          .select('*')
          .eq('user_id', userId)
          .order('date', ascending: false);
      
      print('Number of records: ${response.length}');
      
      _transactions = [];
      for (var record in response) {
        final transaction = TransactionModel.fromMap(record);
        _transactions.add(transaction);
        print('Added: ${transaction.title} - \$${transaction.amount}');
      }
      
      print('Total loaded: ${_transactions.length}');
      
    } catch (e) {
      print('Load Error: $e');
      _error = e.toString();
      _transactions = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      print('=== ADDING TRANSACTION ===');
      print('Title: ${transaction.title}');
      
      final data = {
        'user_id': transaction.userId,
        'title': transaction.title,
        'amount': transaction.amount,
        'type': transaction.type,
        'date': transaction.date.toIso8601String().split('T')[0],
      };
      
      await SupabaseConfig.client.from('transactions').insert(data);
      print('Transaction added successfully!');
      
      await loadTransactions(transaction.userId);
      
    } catch (e) {
      print('Add Error: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(int id, String userId) async {
    try {
      print('=== DELETING TRANSACTION ===');
      print('Transaction ID: $id');
      
      await SupabaseConfig.client.from('transactions').delete().eq('id', id);
      print('Transaction deleted!');
      
      await loadTransactions(userId);
      
    } catch (e) {
      print('Delete Error: $e');
      _error = e.toString();
      notifyListeners();
    }
  }
}
