import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_manager.dart';
import '../providers/currency_provider.dart';
import 'add_transaction_screen.dart';
import 'theme_selector_screen.dart';
import 'stats_screen.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

class PremiumHomeScreen extends StatefulWidget {
  const PremiumHomeScreen({super.key});

  @override
  State<PremiumHomeScreen> createState() => _PremiumHomeScreenState();
}

class _PremiumHomeScreenState extends State<PremiumHomeScreen> {
  int _selectedNavIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    if (auth.isLoggedIn) {
      await transactionProvider.loadTransactions(auth.userId);
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final primaryColor = themeManager.primaryColor;

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      floatingActionButton: _selectedNavIndex == 0
          ? FloatingActionButton(
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
                setState(() {});
              },
              child: const Icon(Icons.add),
              backgroundColor: primaryColor,
              tooltip: 'Add Transaction',
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          child: Column(
            children: [
              _buildTopNavBar(primaryColor),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedNavIndex = index;
                    });
                  },
                  children: [
                    _buildHomeScreen(auth, transactionProvider, currencyProvider, primaryColor),
                    const StatsScreen(),
                    const WalletScreen(),
                    const ProfileScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0, primaryColor),
          _buildNavItem(Icons.bar_chart_outlined, Icons.bar_chart, 'Stats', 1, primaryColor),
          _buildNavItem(Icons.wallet_outlined, Icons.wallet, 'Wallet', 2, primaryColor),
          _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3, primaryColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData filledIcon, String label, int index, Color primaryColor) {
    final isSelected = _selectedNavIndex == index;
    
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? filledIcon : icon,
            color: isSelected ? primaryColor : Colors.white.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.white.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen(AuthProvider auth, TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildPremiumHeader(auth, primaryColor),
          const SizedBox(height: 20),
          _buildBalanceCard(transactionProvider, currencyProvider, primaryColor),
          const SizedBox(height: 20),
          _buildSpendingInsights(transactionProvider, currencyProvider, primaryColor),
          const SizedBox(height: 20),
          _buildRecentTransactions(transactionProvider, currencyProvider, primaryColor),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(AuthProvider auth, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.userEmail?.split('@')[0] ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.palette, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ThemeSelectorScreen()),
              );
            },
            tooltip: 'Change Theme',
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.currency_exchange, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          currencyProvider.currencySymbol,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: transactionProvider.balance),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) => Text(
                  '${currencyProvider.currencySymbol}${value.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                curve: Curves.easeOutCubic,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceMetric('Income', '${currencyProvider.currencySymbol}${transactionProvider.totalIncome.toStringAsFixed(2)}', Colors.green),
                  _buildBalanceMetric('Expenses', '${currencyProvider.currencySymbol}${transactionProvider.totalExpense.toStringAsFixed(2)}', Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceMetric(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingInsights(TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    Map<String, double> categorySpending = {};
    for (var t in transactionProvider.transactions) {
      if (t.type == 'expense') {
        String category = _getCategory(t.title);
        categorySpending[category] = (categorySpending[category] ?? 0) + t.amount;
      }
    }
    
    double totalExpense = transactionProvider.totalExpense;
    
    if (categorySpending.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(
            child: Text(
              'Add expenses to see insights',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: ${currencyProvider.currencySymbol}${totalExpense.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...categorySpending.entries.map((entry) {
              double percentage = (entry.value / totalExpense) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildCategoryItem(entry.key, percentage, _getCategoryColor(entry.key, primaryColor), entry.value, currencyProvider),
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

  Widget _buildCategoryItem(String category, double percentage, Color color, double amount, CurrencyProvider currencyProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              '${currencyProvider.currencySymbol}${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.white.withOpacity(0.1),
          color: color,
          borderRadius: BorderRadius.circular(10),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(TransactionProvider transactionProvider, CurrencyProvider currencyProvider, Color primaryColor) {
    if (transactionProvider.transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Icon(Icons.receipt_long, size: 64, color: Colors.white.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(
                'No transactions yet',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to add your first transaction',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${transactionProvider.transactions.length} Total',
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionProvider.transactions.length > 10 ? 10 : transactionProvider.transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final transaction = transactionProvider.transactions[index];
                return _buildTransactionItem(transaction, currencyProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction, CurrencyProvider currencyProvider) {
    final isIncome = transaction.type == 'income';
    final amountValue = transaction.amount is double ? transaction.amount : double.parse(transaction.amount.toString());
    final amountDisplay = isIncome ? '+${amountValue.toStringAsFixed(2)}' : '-${amountValue.toStringAsFixed(2)}';
    final color = isIncome ? Colors.green : Colors.red;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.trending_up : Icons.trending_down,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${currencyProvider.currencySymbol}$amountDisplay',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
