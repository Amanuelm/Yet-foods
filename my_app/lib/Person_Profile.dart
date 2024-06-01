import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _image;
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _fullNameController.text = userDoc['name'];
          _emailController.text = userDoc['email'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _fullNameController.text,
        'email': _emailController.text,
      });

      if (_emailController.text.isNotEmpty) {
        await user.updateEmail(_emailController.text);
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Adjust this as necessary to navigate to your login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 248, 232),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: 
      Container(
        child:  SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Container(  
    child: Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                    size: 60,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(_fullNameController, 'Full Name', Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email', Icons.email),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom( 
    backgroundColor: const Color.fromARGB(255, 91, 255, 132), // Change background color to green
  ),
          onPressed: () async {
            await _updateUserProfile();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          },
          child: const Text('Update Profile'),
        ),
      ],
    ),
  ),
),
    ));}

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
