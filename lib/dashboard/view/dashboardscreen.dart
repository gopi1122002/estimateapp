import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'businessscreen.dart';
import '../../Menu/profilescreen.dart';
import 'editscreenprofile.dart';
import '../../Menu/newestimate.dart';
import '../../Menu/viewestimate.dart'; // Add this import
import '../../Menu/invoice.dart';
class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? estimateDetails;

  const DashboardScreen({super.key, this.estimateDetails});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false;
  List<Map<String, dynamic>> recentEstimates = [];

  @override
  void initState() {
    super.initState();
    print('Received estimateDetails: ${widget.estimateDetails}'); // Debug log
    if (widget.estimateDetails != null) {
      setState(() {
        recentEstimates.add(widget.estimateDetails!);
        print('Added to recentEstimates. Count: ${recentEstimates.length}'); // Debug log
      });
    }
  }

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
                  _buildDrawerItem(Icons.receipt_long_outlined, "New Estimate", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewEstimateScreen()));
                  }),
                  _buildDrawerItem(Icons.visibility, "View Estimates", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewEstimateScreen(estimates: recentEstimates)),
                    );
                  }),
                  _buildDrawerItem(Icons.settings, "Setting"),
                  _buildDrawerItem(Icons.notifications_none, "Notification"),
                  _buildDrawerItem(Icons.person_outline, "Profile", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  }),
                  _buildDrawerItem(Icons.edit_note_outlined, "Edit Profile", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                  }),
                  _buildDrawerItem(Icons.star_border, "Rating"),
                  _buildDrawerItem(Icons.help_outline, "FAQ"),
                  _buildDrawerItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                  _buildDrawerItem(Icons.logout, "Logout", onTap: () {
                    _showLogoutDialog(context);
                  }),
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
                  value: '',
                  subtitle: 'Generated in last month',
                  percentage: 55,
                ),
                _buildDashboardCard(
                  title: 'TOTAL REVENUE',
                  value: '',
                  subtitle: 'Revenue from accepted estimates',
                  icon: Icons.attach_money,
                  percentage: 75,
                ),
                _buildDashboardCard(
                  icon: Icons.show_chart,
                  title: 'AVERAGE ESTIMATE',
                  value: '',
                  subtitle: 'Based on all estimates',
                  percentage: 60,
                ),
                _buildDashboardCard(
                  icon: Icons.access_time,
                  title: 'PENDING ESTIMATES',
                  value: '',
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
            if (recentEstimates.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (var estimate in recentEstimates)
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text('Customer: ${estimate['customer']['name']}',
                        style: const TextStyle(fontSize: 16)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Navigating to InvoiceScreen with estimate: $estimate');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceScreen(estimate: estimate),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.blue),
                          child: const Text('View'),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     // Mark as complete logic (placeholder)
                        //   },
                        //   style: TextButton.styleFrom(foregroundColor: Colors.green),
                        //   child: const Text('Complete'),
                        // ),
                      ],
                    ),
                  ),
                ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('No recent estimates available.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            ],
            // Temporary refresh button for testing
            // ElevatedButton(
            //   onPressed: () => setState(() {}),
            //   child: const Text('Refresh'),
            // ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Center(child: Text("Logout")),
          content: const Text("Are you sure you want to logout?"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          titlePadding: const EdgeInsets.only(top: 24, bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF6ED7B9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF6ED7B9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _logout(context);
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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