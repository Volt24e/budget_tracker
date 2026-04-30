import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencySymbol = "\$";
  static const String _currencyKey = 'currency_symbol';
  
  String get currencySymbol => _currencySymbol;
  
  CurrencyProvider() {
    _loadCurrency();
  }
  
  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currencySymbol = prefs.getString(_currencyKey) ?? "\$";
    notifyListeners();
  }
  
  Future<void> setCurrency(String symbol) async {
    _currencySymbol = symbol;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, symbol);
    notifyListeners();
  }
  
  List<Map<String, String>> getAvailableCurrencies() {
    return [
      {"symbol": "\$", "name": "USD - US Dollar"},
      {"symbol": "€", "name": "EUR - Euro"},
      {"symbol": "£", "name": "GBP - British Pound"},
      {"symbol": "¥", "name": "JPY - Japanese Yen"},
      {"symbol": "₹", "name": "INR - Indian Rupee"},
      {"symbol": "₽", "name": "RUB - Russian Ruble"},
      {"symbol": "₩", "name": "KRW - South Korean Won"},
      {"symbol": "C\$", "name": "CAD - Canadian Dollar"},
      {"symbol": "A\$", "name": "AUD - Australian Dollar"},
    ];
  }
}
