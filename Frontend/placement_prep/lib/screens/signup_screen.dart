import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
   final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
 final TextEditingController comfirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


Future<void> _handleSignup() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirmPassword = comfirmPasswordController.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All fields are required')),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match')),
    );
    return;
  }

  try {
    final url = Uri.parse('http://192.168.29.61:3000/candidate/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if(!mounted) return; // Check if the widget is still mounted before showing SnackBar

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Signup failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
          
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Email Label
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text('Full Name'),
                ),
              ),

              // Password TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: TextField(
                  controller: nameController,
                
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text('Email'),
                ),
              ),

              // Email TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Password Label
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text('Password'),
                ),
              ),

              // Password TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'At least 6 characters',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
                Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text('Confirm password'),
                ),
              ),

              // Password TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: TextField(
                  controller: comfirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'At least 6 characters',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
                

            

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: () {
                    _handleSignup();
                  },
                  child: const Text('Register'),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              TextButton(
                onPressed: () {
                  // Navigate to register
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Already have an account? Sign in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}