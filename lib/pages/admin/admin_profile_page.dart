import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final db = HabitDatabases();
    await db.init();
    final result = await db.getUserProfile(widget.userId);
    setState(() => user = result);
  }

  void _showDeleteConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Hapus permanent akun user?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final db = HabitDatabases();
                    bool success = await db.deleteUser(widget.userId);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Account deleted successfully')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to delete account')),
                      );
                    }
                  },
                  child: const Text(
                    'Hapus',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleActiveStatus() async {
    if (user == null) return;

    final db = HabitDatabases();
    bool currentStatus = user!['active_flag'];
    bool newStatus = !currentStatus;

    bool success = await db.toggleUserActiveStatus(widget.userId, newStatus);
    if (success) {
      setState(() {
        user!['active_flag'] = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Account status updated to ${newStatus ? "Active" : "Inactive"}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update account status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    print(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      const Color(0xFFD3EBFD),
                  child: Image.asset('assets/avatar.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!['full_name'] ?? user!['username'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user!['email'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: const Color(0xFFF6F8FA),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Container(
                      margin:
                          const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: _buildInfoRow(
                          Icons.person, "FULL NAME", user!['full_name'] ?? '','ic_avatar')),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child:
                          _buildInfoRow(Icons.email, "EMAIL", user!['email'],'ic_email')),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: _buildInfoRow(Icons.phone, "PHONE NUMBER",
                          user!['phone_number'] ?? '','ic_phone')),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _toggleActiveStatus,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: user!['active_flag'] == true
                            ? const Color.fromRGBO(200, 255, 188, 1)
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          user!['active_flag'] == true ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: user!['active_flag'] == true
                                ? const Color(0xFF4CAF50)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 2,),
            GestureDetector(
              onTap: _showDeleteConfirmationDialog,
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.black),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hapus akun",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Akun ini akan dihapus secara permanent\ndan tidak akan bisa diakses lagi oleh user.",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,String ic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/$ic.png',width: 32,),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}