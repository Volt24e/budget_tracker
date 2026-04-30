import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_manager.dart';
import 'theme_selector_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final primaryColor = themeManager.primaryColor;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(context, auth, primaryColor),
          const SizedBox(height: 20),
          _buildStatsGrid(auth),
          const SizedBox(height: 20),
          _buildPreferencesCard(context, currencyProvider, themeManager, primaryColor),
          const SizedBox(height: 20),
          _buildAccountActions(context, auth, primaryColor),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider auth, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.userEmail?.split('@')[0] ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.userEmail ?? 'No email',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Premium User',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(Icons.attach_money, 'Total Saved', '₹0', Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(Icons.calendar_today, 'Member Since', '2024', Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(Icons.people, 'Friends', '0', Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
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
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context, CurrencyProvider currencyProvider, ThemeManager themeManager, Color primaryColor) {
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
              'Preferences',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPreferenceItem(
              'Currency',
              currencyProvider.currencySymbol,
              Icons.currency_exchange,
              () => _showCurrencyDialog(context, currencyProvider),
            ),
            const Divider(color: Colors.white24),
            _buildPreferenceItem(
              'Theme',
              themeManager.themeName,
              Icons.palette,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThemeSelectorScreen()),
                );
              },
            ),
            const Divider(color: Colors.white24),
            _buildPreferenceItem(
              'Notifications',
              'On',
              Icons.notifications,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: Colors.white.withOpacity(0.6))),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildAccountActions(BuildContext context, AuthProvider auth, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.white),
                  title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy coming soon!')),
                    );
                  },
                ),
                const Divider(color: Colors.white24, height: 1),
                ListTile(
                  leading: const Icon(Icons.description, color: Colors.white),
                  title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of Service coming soon!')),
                    );
                  },
                ),
                const Divider(color: Colors.white24, height: 1),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.white),
                  title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, CurrencyProvider currencyProvider) {
    final currencies = currencyProvider.getAvailableCurrencies();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3F),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Currency',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white24),
            ...currencies.map((currency) => ListTile(
              leading: Text(currency['symbol']!, style: const TextStyle(fontSize: 24, color: Colors.white)),
              title: Text(currency['name']!, style: const TextStyle(color: Colors.white)),
              trailing: currencyProvider.currencySymbol == currency['symbol']
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                currencyProvider.setCurrency(currency['symbol']!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Currency changed to ${currency['name']}')),
                );
              },
            )).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
