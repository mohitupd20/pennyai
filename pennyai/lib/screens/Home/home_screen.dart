import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennyai/screens/expenditure/expenditure.dart';
import 'package:pennyai/screens/penny_assistant/penny_assistant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF5E72E4),
        elevation: 0,
      ),
      body: SafeArea(
    child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBalanceCard(),
        const SizedBox(height: 20),
        _buildQuickActions(context), // <-- Pass context here
        const SizedBox(height: 20),
        _buildRecentTransactions(),
      ],
    ),
    ),
    ),

    bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5E72E4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$4,250.75',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '+\$320 this month',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                emoji: '💰',
                label: 'Add Expense',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenditureScreen(),
                  ),
                ),
                color: const Color(0xFFF0F5FF),
              ),
              _buildActionButton(
                emoji: '📊',
                label: 'Budget',
                onTap: () {},
                color: const Color(0xFFF0F5FF),
              ),
              _buildActionButton(
                emoji: '🤖',
                label: 'Ask Penny',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PennyAssistantScreen()),
                ),
                color: const Color(0xFFF0FFF0),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildActionButton({
    required String emoji,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = [
      {
        'icon': '🛒',
        'title': 'Grocery Store',
        'date': 'Today',
        'amount': -42.30,
      },
      {
        'icon': '☕',
        'title': 'Coffee Shop',
        'date': 'Yesterday',
        'amount': -4.50,
      },
      {
        'icon': '💵',
        'title': 'Salary Deposit',
        'date': 'March 15',
        'amount': 1450.00,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...transactions.map((transaction) => _buildTransactionItem(transaction)),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isExpense = transaction['amount'] < 0;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(
            transaction['icon'],
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  transaction['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            formatter.format(transaction['amount'].abs()),
            style: TextStyle(
              fontSize: 14,
              color: isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Text('🏠', style: TextStyle(fontSize: 16)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Text('📊', style: TextStyle(fontSize: 16)),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Text('👤', style: TextStyle(fontSize: 16)),
          label: 'Profile',
        ),
      ],
      selectedItemColor: const Color(0xFF5E72E4),
      unselectedItemColor: Colors.grey,
    );
  }
}