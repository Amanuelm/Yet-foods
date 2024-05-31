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
      initialRoute: '/',
      routes: {
        '/': (context) => IntroPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(), 
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const IntroPage(),
//         '/login': (context) => LoginPage(),
//         '/home': (context) => const HomePage(),
//         '/signup': (context) =>  SignUpPage(),

        
//       },
//     );
//   }
// }
