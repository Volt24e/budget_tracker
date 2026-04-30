import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final String userId;
  final String currencySymbol;
  
  const AddTransactionScreen({super.key, required this.userId, required this.currencySymbol});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedType = "expense";
  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;

  final List<String> _expenseMemes = [
    "🤡 Bro spent money on THAT?",
    "💸 Your wallet is crying!",
    "😱 That's... a choice!",
    "🍕 Could've bought pizza!",
    "🎮 Should've bought a game!",
    "☕ That's a lot of coffee!",
    "💀 RIP your bank account",
    "🛑 Stop spending!",
    "😭 Your money is gone!",
    "🎯 That's not saving!",
  ];
  
  final List<String> _incomeMemes = [
    "🤑 Look at Mr. Moneybags!",
    "💰 Cha-ching!",
    "🎉 Time to celebrate!",
    "💪 Keep it up!",
    "🦄 Rare money sighting!",
    "✨ Manifestation works!",
    "📈 Stonks!",
    "💃 Money dance!",
    "🥳 Party at your place!",
    "🏦 Bank account happy!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount (${widget.currencySymbol})",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(value: "expense", child: Text("Expense 💸")),
                DropdownMenuItem(value: "income", child: Text("Income 💰")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Date"),
              subtitle: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Save Transaction"),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveTransaction() async {
    if (titleController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final transaction = TransactionModel(
      title: titleController.text,
      amount: amount,
      type: selectedType,
      date: selectedDate,
      userId: widget.userId,
    );

    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    
    await transactionProvider.addTransaction(transaction);
    
    setState(() => _isSaving = false);
    
    if (context.mounted) {
      // Get random meme
      String memeMessage;
      if (selectedType == "expense") {
        memeMessage = _expenseMemes[DateTime.now().millisecondsSinceEpoch % _expenseMemes.length];
      } else {
        memeMessage = _incomeMemes[DateTime.now().millisecondsSinceEpoch % _incomeMemes.length];
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(memeMessage),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: selectedType == "expense" ? Colors.red.shade700 : Colors.green.shade700,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
