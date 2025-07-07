import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dart:ui';
import 'conduct_quiz_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 153, 167, 204),
        elevation: 500,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // slate-900
              Color(0xFF581C87), // purple-900
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.03,
          ),

          child: Column(
            children: [
              _buildWelcomeCard(context),
              SizedBox(height: screenHeight * 0.03),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/task');
                },
                child: _buildProgressCard(context),
              ),
              SizedBox(height: screenHeight * 0.03),

              _buildChallengeCard(context),
              SizedBox(height: screenHeight * 0.03),
              _buildTopicsCard(context),
              SizedBox(height: screenHeight * 0.03),
              _buildActionCard(context),
              SizedBox(height: screenHeight * 0.03),
              _buildAchievementsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return _buildCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Atithi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'A great day for practice',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          // Remove CircleAvatar and directly display Lottie
          CircleAvatar(
            radius: screenWidth * 0.12,
            backgroundColor: DefaultSelectionStyle.defaultColor.withOpacity(0),
            child: Lottie.asset(
              'assets/images/animation/Profile.json',
              repeat: true,
              width: screenWidth * 0.4,
              height: screenHeight*0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * .02),
          LinearProgressIndicator(
            value: 0.65,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(height: screenHeight * .01),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '65%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Challenge',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Solve the problem of the day',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dailyquestion');
            },
            child: Text('Try Now'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsCard(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Topics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * .02),

          // HORIZONTAL SCROLLABLE TOPICS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTopicButton(context, 'Array', '⊞', Colors.orange),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'String', '🔤', Colors.teal),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'Stack', '📚', Colors.deepOrange),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'Tree', '🌳', Colors.purple),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'DP', '↻', Colors.blue),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'Heap', '⛏', Colors.red),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'Graph', '📈', Colors.green),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'Queue', '📬', Colors.indigo),
                SizedBox(width: screenwidth * 0.04),
                _buildTopicButton(context, 'LinkedList', '🔗', Colors.cyan),
                SizedBox(width: screenwidth * 0.04),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * .02),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Review Mistakes',
                  '📝',
                  Colors.white24,
                ),
              ),
              SizedBox(width: screenwidth * .04),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Mock Interview',
                  '💬',
                  Colors.pink.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicButton(
    BuildContext context,
    String title,
    String emoji,
    Color color,
  ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConductQuizScreen(defaultOption: title),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(screenwidth * .06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenwidth * 0.04),
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: screenHeight * .01),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String emoji,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Opening $title! $emoji')));
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context) {
    return _buildCard(
      child: ListTile(
        leading: Text('🏆', style: TextStyle(fontSize: 24)),
        title: Text(
          'Achievements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Viewing achievements! 🏆')));
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: child,
        ),
      ),
    );
  }
}
