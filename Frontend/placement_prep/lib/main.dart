import 'package:flutter/material.dart';
import 'package:placement_prep/screens/task_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/signup_screen.dart';
import 'screens/daily_question_screen.dart';
import 'screens/conduct_quiz_screen.dart';
  void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Placement Prep App',
        
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/task': (context) =>  DailyTaskScreen(),
        '/dailyquestion': (context) => DailyQuestionScreen(),
        '/conductquiz': (context) => ConductQuizScreen(defaultOption: 'Array'), // Default option can be changed
        '/home': (context)=> HomeScreen()
      },
          theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 232, 234, 255), // Dark Indigo

        scaffoldBackgroundColor: Colors.white,

        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color.fromARGB(255, 208, 209, 225), // "Forgot your password?" color
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(188, 20, 159, 252), // Button background
            foregroundColor: Colors.white, // Button text color
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            
          ),
        ),
         textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color.fromARGB(255, 206, 209, 238),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),

  ),
  inputDecorationTheme:  InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
    filled: true,
    fillColor: Colors.white.withOpacity(0.2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),


      ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: Colors.black,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[800],
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Consumer<AuthProvider>(
            builder: (ctx, auth, _) {
              debugPrint("Building MaterialApp with auth: ${auth.isAuthenticated}");
              return auth.isAuthenticated ? HomeScreen()  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
