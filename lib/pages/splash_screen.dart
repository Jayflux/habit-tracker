import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    final db = HabitDatabases();
    
      var Fluttertoast;

  @override
  void initState() {
    super.initState();
    // createAdminUser(context);
      _initializeApp();
    // _navigateToHome();
  }


void _initializeApp() async {
    await db.init();             
  await createAdminUser();  
  if (!mounted) return;    
  _navigateToHome();
}


Future<void> createAdminUser() async {
  const email = 'admin@gmail.com';
  const password = 'admin123';

  try {
    final existingUser = await db.login(email, password);

    if (existingUser == null) {
      await db.register('admin', email, password,'',',');
      print("✅ Admin created");
    } else {
      print("ℹ️ Admin already exists");
    }
  } catch (e) {
    print("Login failed: $e");
  }
}

  

  


  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3)); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/habit.png', width: 100,),  
      ),
    );
  }
}