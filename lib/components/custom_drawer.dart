import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/pages/about_page.dart';
import 'package:habit_tracker/pages/history_page.dart';
// import 'package:habit_tracker/pages/reminder_page.dart';

class CustomDrawer extends StatefulWidget {
  final String username;
  final int userId; // Tambahkan userId untuk navigasi ke history/reminder

  const CustomDrawer({super.key, required this.username, required this.userId});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final HabitDatabases db = HabitDatabases();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Avatar
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Username
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              widget.username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(
            thickness: 2,
            height: 30,
            color: Colors.white24,
          ),

          // Menu Items
          drawerItem(
              iconData: Icons.home,
              label: 'Home',
              onTap: () {
                Navigator.pop(context); // kembalikan ke Home
              }),
          drawerItem(iconData: Icons.settings, label: 'Settings', onTap: () {}),
          drawerItem(
            iconData: Icons.history,
            label: 'History',
            onTap: () {
              Navigator.pop(context); // tutup drawer dulu
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(userId: widget.userId),
                ),
              );
            },
          ),
          drawerItem(
            iconData: Icons.notifications,
            label: 'Reminder',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage(userId: widget.userId)));
            },
          ),
          drawerItem(
              iconData: Icons.person_add, label: 'Invite Friend', onTap: () {}),
          drawerItem(
              iconData: Icons.share, label: 'Rate the App', onTap: () {}),
          drawerItem(
            iconData: Icons.info_outline,
            label: 'About Us',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OurTeamPage()),
              );
            },
          ),

          const Spacer(),

          // Sign Out
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24)),
            ),
            child: GestureDetector(
              onTap: () {
                db.todaysHabitList.clear();
                db.heatMapDataSet.clear();

                setState(() {}); // opsional, hanya jika perlu refresh

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Sign Out', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.logout, color: Colors.redAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem({
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(iconData, color: Colors.white70),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
