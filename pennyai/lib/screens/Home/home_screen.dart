import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennyai/screens/expenditure/expenditure.dart';
import 'package:pennyai/screens/penny_assistant/penny_assistant.dart';
import 'package:pennyai/screens/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Penny AI'),
        backgroundColor: const Color(0xFF5E72E4),
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            radius: 15,
            child: const Text('👤', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 10),
              _buildBudgetCard(),
              const SizedBox(height: 10),
              _buildRecentExpenses(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Balance',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 5),
                const Text(
                  '\$4,285.75',
                  style: TextStyle(
                    color: Color(0xFF2DCE89),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF5E72E4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('💲', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Budget',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF5E72E4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('📊', style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  color: const Color(0xFFE9ECEF),
                ),
                Container(
                  height: 8,
                  color: const Color(0xFF5E72E4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$1,950 spent',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
              Text(
                '\$3,000 budget',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses() {
    final expenses = [
      {
        'emoji': '🍔',
        'category': 'Restaurants',
        'date': 'Yesterday',
        'amount': -47.80,
      },
      {
        'emoji': '🏠',
        'category': 'Rent',
        'date': 'Apr 1',
        'amount': -1200.00,
      },
      {
        'emoji': '🛒',
        'category': 'Groceries',
        'date': 'Mar 30',
        'amount': -89.45,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Expenses',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all expenses
                },
                child: Text(
                  'See All →',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...expenses.map((expense) => _buildExpenseItem(expense)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(Map<String, dynamic> expense) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(expense['emoji'], style: const TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense['category'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      expense['date'],
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Text(
                '${expense['amount'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // if (expense != expenses.last)
        //   const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenditureScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PennyAssistantScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Text('🏠', style: TextStyle(fontSize: 18)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Text('💰', style: TextStyle(fontSize: 18)),
          label: 'Expense',
        ),
        BottomNavigationBarItem(
          icon: Text('🤖', style: TextStyle(fontSize: 18)),
          label: 'Penny',
        ),
        BottomNavigationBarItem(
          icon: Text('👤', style: TextStyle(fontSize: 18)),
          label: 'Profile',
        ),
      ],
      selectedItemColor: const Color(0xFF5E72E4),
      unselectedItemColor: Colors.grey.shade600,
    );
  }
}