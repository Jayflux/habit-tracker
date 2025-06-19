import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/pages/admin/admin_profile_page.dart';
import 'package:habit_tracker/pages/login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, dynamic>> users = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final db = HabitDatabases();
    await db.init();
    final result = await db.getAllUsers();
    setState(() => users = result);
  }

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF174E8F),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Users",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: const Color(0xFFD3EBFD),
                              child: Image.asset('assets/avatar.png'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: user['active_flag'] == 1 ? Colors.lightGreen : Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          user['full_name'] ?? user['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        subtitle: Text(
                          user['email'],
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(userId: user['id']),
                            ),
                          );
                          fetchUsers();
                        },
                      ),
                      const Divider(height: 1, thickness: 1, color: Colors.black12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: Colors.blue.shade700,
      width: 250,
      child: Column(
        children: [
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF174E8F), size: 40),
                ),
                const SizedBox(height: 12),
                const Text("Admin", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: "Home",
            index: 0,
            onTap: () => _onDrawerItemTap(0),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: "Settings",
            index: 1,
            onTap: () => _onDrawerItemTap(1),
          ),
          _buildDrawerItem(
            icon: Icons.group_add,
            text: "Invite Friends",
            index: 2,
            onTap: () => _onDrawerItemTap(2),
          ),
          _buildDrawerItem(
            icon: Icons.share,
            text: "Share the App",
            index: 3,
            onTap: () => _onDrawerItemTap(3),
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: "About Us",
            index: 4,
            onTap: () => _onDrawerItemTap(4),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedDrawerIndex == index;
    return Material(
      color: isSelected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(isSelected ? 25 : 0),
        bottomRight: Radius.circular(isSelected ? 25 : 0),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: isSelected
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              )
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF174E8F) : Colors.white),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}