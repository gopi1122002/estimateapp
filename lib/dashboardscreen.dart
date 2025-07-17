import 'package:flutter/material.dart';
import 'businessscreen.dart';
import 'profilescreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6ED7B9),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.toggle_on : Icons.toggle_off,
              size: 45,
              color: isDarkMode ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.home, "Home"),
                  _buildDrawerItem(Icons.apartment, "Business Details", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessDetailsScreen()));
                  }),
                  _buildDrawerItem(Icons.receipt_long_outlined, "New Estimate"),
                  _buildDrawerItem(Icons.settings, "Setting"),
                  _buildDrawerItem(Icons.notifications_none, "Notification"),
                  _buildDrawerItem(Icons.person_outline, "Profile", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  }),
                  _buildDrawerItem(Icons.edit_note_outlined, "Edit Profile"),
                  _buildDrawerItem(Icons.star_border, "Rating"),
                  _buildDrawerItem(Icons.help_outline, "FAQ"),
                  _buildDrawerItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                  _buildDrawerItem(Icons.logout, "Logout"),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard(
                  icon: Icons.description_outlined,
                  title: 'TOTAL ESTIMATES',
                  value: '120',
                  subtitle: 'Generated in last month',
                  percentage: 55,
                ),
                _buildDashboardCard(
                  title: 'TOTAL REVENUE',
                  value: '\$35,000',
                  subtitle: 'Revenue from accepted estimates',
                  icon: Icons.attach_money,
                  percentage: 75,
                ),
                _buildDashboardCard(
                  icon: Icons.show_chart,
                  title: 'AVERAGE ESTIMATE',
                  value: '\$291.67',
                  subtitle: 'Based on all estimates',
                  percentage: 60,
                ),
                _buildDashboardCard(
                  icon: Icons.access_time,
                  title: 'PENDING ESTIMATES',
                  value: '15',
                  subtitle: 'Estimates awaiting approval',
                  percentage: 40,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent estimates',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // Add recent estimate widgets if needed
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF18A076)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required int percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 12),
          Icon(icon, size: 35, color: Colors.teal),
        ],
      ),
    );
  }
}
