import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
  padding: const EdgeInsets.only(top: 20.0), // Adjust top padding as needed
  child: Icon(
    Icons.account_circle,
    size: 190.0,
    color: Color.fromARGB(255, 2, 234, 60),
  ),),
            const Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(style: TextStyle(color: Color.fromARGB(255, 2, 234, 60)),
              decoration: InputDecoration(labelText: 'Phone number'),
            ),
            const TextField(style: TextStyle(color: Color.fromARGB(255, 2, 234, 60)),
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                   onPressed: () {
    // Navigate to Login Page
                    Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom( 
    backgroundColor: Color.fromARGB(255, 236, 15, 15), // Change background color to green
  ),
              child: SizedBox(
               width:170.0, // Adjust width as needed
              height: 60.0, // Adjust height as needed
             child: Center( 
              child: const Text('Log In',style: TextStyle(color:Color.fromARGB(255, 252, 252, 252),fontSize: 20)),)
              ),
              ),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text("Don't have an account? Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}