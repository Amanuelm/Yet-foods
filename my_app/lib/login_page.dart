import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// TextEditingControllers for login fields
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 217, 255, 228),
        title: const Text('Login'),
      ),
      body: Container(
  color: Color.fromARGB(255, 246, 255, 249), // Set your desired background color here
  padding: const EdgeInsets.all(20.0), // Adjust padding values as needed
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(),
              child: const Text('Login'),
              style: ElevatedButton.styleFrom( 
    backgroundColor: Color.fromARGB(255, 2, 234, 60), // Change background color to green
  ),
            ),
             
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Basic email validation (optional)
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email address.'),
          ),
        );
        return;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigate to your home screen (replace with your route name)
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (error) {
      String message = 'An error occurred.';
      switch (error.code) {
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'user-disabled':
          message = 'The user account has been disabled.';
          break;
        case 'user-not-found':
          message = 'The user account does not exist.';
          break;
        case 'wrong-password':
          message = 'The password is incorrect.';
          break;
        default:
          // Handle other errors
          print(error.code); // Log the error for debugging
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      print(error); // Log the error for debugging (e.g., network errors)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
        ),
      );
    }
  }
}