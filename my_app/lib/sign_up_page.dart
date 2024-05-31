import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// TextEditingControllers for sign-up fields
final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController(); // Optional
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (Optional)',
              ),
              keyboardType: TextInputType.phone, // Optional for phone number input
            ),
            const SizedBox(height: 10.0),
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
              onPressed: () => _createUserWithEmailAndPassword(),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim(); // Optional
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

      // Basic password validation (optional)
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password must be at least 6 characters long.'),
          ),
        );
        return;
      }

      print('Creating user with email: $email');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print('User created: ${user?.uid}');

      // Implement logic to store user data (name, phone) in your database (if applicable)
      // For example, using Firestore:
      // await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      //   'name': name,
      //   'phone': phone,
      //   'email': email,
      // });

      // Navigate to your home screen (replace with your route name)
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (error) {
      print('FirebaseAuthException: ${error.code}, ${error.message}');
      String message = 'An error occurred.';
      switch (error.code) {
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'user-disabled':
          message = 'The user account has been disabled.';
          break;
        case 'user-already-in-use':
          message = 'The email address is already in use.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        default:
          // Handle other errors
          message = 'Error: ${error.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      print('Unexpected error: $error'); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
        ),
      );
    }
  }
}
