import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'sign_up_page.dart'; 
import 'home_page.dart';
import 'login_page.dart';
import 'intro.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(), 
        '/signup': (context) => SignUpPage(), 
      },
    );
  }
}
