import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashAfterLoginPage extends StatefulWidget {
  final int userId;
  final String username;

  const SplashAfterLoginPage({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<SplashAfterLoginPage> createState() => _SplashAfterLoginPageState();
}

class _SplashAfterLoginPageState extends State<SplashAfterLoginPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          userId: widget.userId,
          username: widget.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF195497), // warna biru
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/habit2.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome\n${widget.username}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
