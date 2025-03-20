import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF5E72E4),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Text('⚙️', style: TextStyle(fontSize: 18)),
            onPressed: () {
              // Open settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 10),
              _buildStatsSection(),
              const SizedBox(height: 15),
              _buildMenuItems(),
              const SizedBox(height: 15),
              _buildLanguagePreferences(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Center(
              child: Text('👤', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Alex Johnson',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'alex.johnson@example.com',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            value: '\$6,500',
            label: 'Saved',
          ),
          _buildStatItem(
            value: '18%',
            label: 'Saving Rate',
          ),
          _buildStatItem(
            value: '\$10,000',
            label: 'Goal',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': '📊', 'title': 'Financial Goals'},
      {'icon': '📱', 'title': 'Connected Accounts'},
      {'icon': '🔒', 'title': 'Privacy & Security'},
      {'icon': '🔔', 'title': 'Notifications'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Text(item['icon']!, style: const TextStyle(fontSize: 14)),
                title: Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const Text('→', style: TextStyle(fontSize: 14)),
                onTap: () {
                  // Navigate to the specific section
                },
              ),
              if (index < menuItems.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLanguagePreferences() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Language Preferences',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildLanguageChip(
                flag: '🇺🇸',
                language: 'English',
                isSelected: true,
              ),
              const SizedBox(width: 10),
              _buildLanguageChip(
                flag: '🇪🇸',
                language: 'Spanish',
                isSelected: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildLanguageChip(
            flag: '🇫🇷',
            language: 'French',
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip({
    required String flag,
    required String language,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5E72E4) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flag, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 5),
          Text(
            language,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
        // Other navigation options can be added here
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Text('🏠', style: TextStyle(fontSize: 18)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Text('📊', style: TextStyle(fontSize: 18)),
          label: 'Insights',
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