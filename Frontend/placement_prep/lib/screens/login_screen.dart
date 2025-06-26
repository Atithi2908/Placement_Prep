import 'package:flutter/material.dart';
import 'package:placement_prep/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
      
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A), // slate-900
                Color(0xFF581C87), // purple-900
                Color(0xFF0F172A), // slate-900
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ) ,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Icon(
                    Icons.laptop,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Text(
                    'PlacementPrep',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                
                  // Email Label
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
                      style: TextStyle(color: Colors.white),
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
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'At least 6 characters',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: const Text('Forgot your password?'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                
                  ElevatedButton(
                    onPressed: () async {
                      final auth = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      debugPrint("Auth in login screen after success: ${auth.isAuthenticated}");
                
                      try {
                        await auth.login(
                          emailController.text,
                          passwordController.text,
                        );
                        
                        debugPrint("Post login in screen. Auth isAuthenticated = ${auth.isAuthenticated}");
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Login failed: $e ')));
                      }
                    },
                    child: const Text('Sign in'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
