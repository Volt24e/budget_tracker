import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final currencies = currencyProvider.getAvailableCurrencies();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Settings"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          final isSelected = currencyProvider.currencyCode == currency["code"];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
              child: Text(
                currency["symbol"]!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(currency["name"]!),
            subtitle: Text("${currency["symbol"]} - ${currency["code"]}"),
            trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () {
              currencyProvider.setCurrency(currency["symbol"]!, currency["code"]!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Currency changed to ${currency["name"]} (${currency["symbol"]})"),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
