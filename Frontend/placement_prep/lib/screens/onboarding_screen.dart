import 'package:flutter/material.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      
      body:Stack(
        children: [
        SizedBox.expand(
        child: Padding(
          padding:const EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/Onboarding_2.png',
        fit: BoxFit.cover,
      ),
        )
        ),
        Positioned(
          top: screenHeight * 0.62,
          left: screenWidth * 0.1,
          child: Text(
            'Welcome to,',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
         Positioned(
          top: screenHeight * 0.67,
          left: screenWidth * 0.1,
          child: Text(
            'PlacementPrep',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.74,
          left: screenWidth * 0.1,
          child: Text(
            'Your dream job starts here\nprepare, practice, and get placed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        
      Positioned(
          top: screenHeight * 0.85,
          left: screenWidth * 0.6,
          right: screenWidth * 0.1,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              '---->',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

      ]
      )
    );
  }
}