import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_manager.dart';

class BillSplitterScreen extends StatefulWidget {
  const BillSplitterScreen({super.key});

  @override
  State<BillSplitterScreen> createState() => _BillSplitterScreenState();
}

class _BillSplitterScreenState extends State<BillSplitterScreen> {
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _numPeopleController = TextEditingController();
  final TextEditingController _tipPercentageController = TextEditingController();
  
  double _totalAmount = 0;
  int _numPeople = 1;
  double _tipPercentage = 0;
  double _perPersonAmount = 0;

  @override
  void initState() {
    super.initState();
    _numPeopleController.text = '1';
  }

  void _calculateSplit() {
    setState(() {
      _totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
      _numPeople = int.tryParse(_numPeopleController.text) ?? 1;
      _tipPercentage = double.tryParse(_tipPercentageController.text) ?? 0;
      
      double tipAmount = _totalAmount * (_tipPercentage / 100);
      double totalWithTip = _totalAmount + tipAmount;
      _perPersonAmount = totalWithTip / _numPeople;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final primaryColor = themeManager.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Splitter'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3F),
              primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildInputSection(context, currencyProvider, primaryColor),
                const SizedBox(height: 20),
                if (_totalAmount > 0) _buildResultSection(context, currencyProvider, primaryColor),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, CurrencyProvider currencyProvider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bill Details',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Total Amount (${currencyProvider.currencySymbol})',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numPeopleController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Number of People',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.people, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tipPercentageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Tip Percentage (%)',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.percent, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateSplit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Calculate Split', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickTipChip('10', primaryColor),
                _buildQuickTipChip('15', primaryColor),
                _buildQuickTipChip('18', primaryColor),
                _buildQuickTipChip('20', primaryColor),
                _buildQuickTipChip('25', primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTipChip(String percent, Color primaryColor) {
    return ActionChip(
      label: Text('$percent% Tip', style: const TextStyle(color: Colors.white)),
      onPressed: () {
        setState(() {
          _tipPercentageController.text = percent;
          _calculateSplit();
        });
      },
      backgroundColor: primaryColor.withOpacity(0.3),
      side: BorderSide(color: primaryColor.withOpacity(0.5)),
    );
  }

  Widget _buildResultSection(BuildContext context, CurrencyProvider currencyProvider, Color primaryColor) {
    double tipAmount = _totalAmount * (_tipPercentage / 100);
    double totalWithTip = _totalAmount + tipAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Split Result',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildResultRow('Total Bill', '${currencyProvider.currencySymbol}${_totalAmount.toStringAsFixed(2)}'),
            _buildResultRow('Tip (${_tipPercentage.toStringAsFixed(0)}%)', '${currencyProvider.currencySymbol}${tipAmount.toStringAsFixed(2)}'),
            _buildResultRow('Total with Tip', '${currencyProvider.currencySymbol}${totalWithTip.toStringAsFixed(2)}'),
            const Divider(color: Colors.white24, height: 24),
            _buildResultRow(
              'Per Person',
              '${currencyProvider.currencySymbol}${_perPersonAmount.toStringAsFixed(2)}',
              isBold: true,
              fontSize: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isBold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: fontSize * 0.8,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _numPeopleController.dispose();
    _tipPercentageController.dispose();
    super.dispose();
  }
}
