import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 150, 
                backgroundImage: AssetImage('assets/circle.jpg'), 
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Elevate your dining.',
                 
                style: TextStyle(
                   
                  fontSize: 40,
                  color: Color.fromARGB(255, 255, 255, 255),
                  
                ),
              ),
              const SizedBox(height: 100),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                   onPressed: () {
                    Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom( 
    backgroundColor: const Color.fromARGB(255, 236, 15, 15), 
  ),
              child: const SizedBox(
               width:170.0, 
              height: 60.0, 
             child: Center( 
              child: Text('Log In',style: TextStyle(color:Color.fromARGB(255, 252, 252, 252),fontSize: 20)),)
              ),
              ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom( 
    backgroundColor: const Color.fromARGB(255, 2, 234, 60), 
  ),
                   child: const SizedBox(
               width: 170.0, 
              height: 60.0, 
             child: Center( 
              child: Text('Sign up',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255),fontSize: 20)),)
              ), 
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}