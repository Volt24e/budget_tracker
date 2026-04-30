import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_manager.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final primaryColor = themeManager.primaryColor;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildSummaryCards(transactionProvider, currencyProvider, primaryColor),
          const SizedBox(height: 20),
          _buildMonthlyOverview(transactionProvider, currencyProvider),
          const SizedBox(height: 20),
          _buildCategoryChart(transactionProvider, currencyProvider, primaryColor),
          const SizedBox(height: 20),
          _buildTopCategories(transactionProvider, currencyProvider),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Income',
              '${currencyProvider.currencySymbol}${transactionProvider.totalIncome.toStringAsFixed(2)}',
              Colors.green,
              Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Expenses',
              '${currencyProvider.currencySymbol}${transactionProvider.totalExpense.toStringAsFixed(2)}',
              Colors.red,
              Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview(TransactionProvider transactionProvider, CurrencyProvider currencyProvider) {
    // Group transactions by month
    Map<String, Map<String, double>> monthlyData = {};
    for (var t in transactionProvider.transactions) {
      String month = '${t.date.year}-${t.date.month}';
      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = {'income': 0, 'expense': 0};
      }
      if (t.type == 'income') {
        monthlyData[month]!['income'] = (monthlyData[month]!['income'] ?? 0) + t.amount;
      } else {
        monthlyData[month]!['expense'] = (monthlyData[month]!['expense'] ?? 0) + t.amount;
      }
    }

    if (monthlyData.isEmpty) {
      return _buildEmptyState('No data for chart');
    }

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
              'Monthly Overview',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...monthlyData.entries.toList().reversed.take(6).map((entry) {
              final income = entry.value['income'] ?? 0;
              final expense = entry.value['expense'] ?? 0;
              final maxValue = income > expense ? income : expense;
              final incomePercent = maxValue > 0 ? (income / maxValue) : 0;
              final expensePercent = maxValue > 0 ? (expense / maxValue) : 0;
              
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getMonthName(entry.key),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text(
                            '+${currencyProvider.currencySymbol}${income.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.green, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '-${currencyProvider.currencySymbol}${expense.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: (incomePercent * 100).toInt(),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: incomePercent > 0.1
                                ? Text(
                                    '${currencyProvider.currencySymbol}${income.toStringAsFixed(0)}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: (expensePercent * 100).toInt(),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: expensePercent > 0.1
                                ? Text(
                                    '${currencyProvider.currencySymbol}${expense.toStringAsFixed(0)}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getMonthName(String yearMonth) {
    List<String> parts = yearMonth.split('-');
    if (parts.length != 2) return yearMonth;
    int month = int.parse(parts[1]);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[month - 1]} ${parts[0]}';
  }

  Widget _buildCategoryChart(TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    Map<String, double> categorySpending = {};
    for (var t in transactionProvider.transactions) {
      if (t.type == 'expense') {
        String category = _getCategory(t.title);
        categorySpending[category] = (categorySpending[category] ?? 0) + t.amount;
      }
    }

    if (categorySpending.isEmpty) {
      return _buildEmptyState('No spending data');
    }

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
              'Spending by Category',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...categorySpending.entries.map((entry) {
              double total = categorySpending.values.fold(0, (sum, val) => sum + val);
              double percentage = (entry.value / total) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(color: Colors.white)),
                        Text(
                          '${currencyProvider.currencySymbol}${entry.value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: _getCategoryColor(entry.key, primaryColor),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCategories(TransactionProvider transactionProvider, CurrencyProvider currencyProvider) {
    Map<String, double> categorySpending = {};
    for (var t in transactionProvider.transactions) {
      if (t.type == 'expense') {
        String category = _getCategory(t.title);
        categorySpending[category] = (categorySpending[category] ?? 0) + t.amount;
      }
    }

    var sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedEntries.isEmpty) {
      return _buildEmptyState('No top categories');
    }

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
              'Top Spending Categories',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...sortedEntries.take(5).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(entry.key, Colors.blue).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(entry.key),
                        color: _getCategoryColor(entry.key, Colors.blue),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          Text(
                            '${entry.value.toStringAsFixed(0)} total',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${currencyProvider.currencySymbol}${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getCategory(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('coffee') || lowerTitle.contains('starbucks')) return 'Coffee';
    if (lowerTitle.contains('food') || lowerTitle.contains('restaurant') || lowerTitle.contains('pizza')) return 'Food';
    if (lowerTitle.contains('game') || lowerTitle.contains('playstation')) return 'Gaming';
    if (lowerTitle.contains('amazon') || lowerTitle.contains('shopping')) return 'Shopping';
    if (lowerTitle.contains('uber') || lowerTitle.contains('taxi')) return 'Transport';
    if (lowerTitle.contains('netflix') || lowerTitle.contains('spotify')) return 'Subscription';
    return 'Other';
  }

  Color _getCategoryColor(String category, Color primaryColor) {
    switch (category) {
      case 'Coffee': return const Color(0xFF6C63FF);
      case 'Food': return const Color(0xFF00B4D8);
      case 'Gaming': return const Color(0xFFE76F51);
      case 'Shopping': return const Color(0xFFF4A261);
      case 'Transport': return const Color(0xFF2E8B57);
      case 'Subscription': return const Color(0xFFE63946);
      default: return primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Coffee': return Icons.coffee;
      case 'Food': return Icons.restaurant;
      case 'Gaming': return Icons.games;
      case 'Shopping': return Icons.shopping_cart;
      case 'Transport': return Icons.directions_car;
      case 'Subscription': return Icons.subscriptions;
      default: return Icons.category;
    }
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.white.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
