import 'package:flutter/material.dart';
import 'dart:ui';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Communities"), backgroundColor: Color.fromARGB(255, 153, 167, 204),
            elevation: 500,),
      body: Expanded(
        child: Container(
          width:double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient( begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 39, 32, 90), Color.fromARGB(255, 48, 46, 86), Color.fromARGB(255, 7, 12, 34)], )
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                  SizedBox(height: screenHeight*0.1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:screenWidth*0.1),
                  child: Row(
                    children: [
                      Expanded(child: toggleCard(context, "joinGroup",0)),
                      SizedBox(width:screenWidth*0.2),
                      Expanded(child: toggleCard(context, "My groups",1)),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                selectedIndex ==0 
                ? _buildJoinGroupsList() : _buildMyGroupsList()
              ],
          
            ),
          ),
        ),
      ),
    );
  }

  Widget toggleCard(BuildContext context, String topic,int index) {
    return GestureDetector(
      onTap:
          () => setState(() {
            selectedIndex = index;
          }),
      child: Container(
        decoration: BoxDecoration(
 color: selectedIndex == index ? Colors.amber : Colors.grey[300],
           borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          topic,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

   Widget _buildJoinGroupsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        title: Text("Join Group #$index", style: TextStyle(color: Colors.white)),
        trailing: TextButton(
          onPressed: () {},
          child: Text("Join"),
        ),
      ),
    );
  }

  Widget _buildMyGroupsList() {
    return ListView.builder(
      shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => ListTile(
        title: Text("My Group #$index", style: TextStyle(color: Colors.white)),
        subtitle: Text("Already joined", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
