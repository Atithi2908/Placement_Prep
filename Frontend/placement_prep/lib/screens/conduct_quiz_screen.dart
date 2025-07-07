import 'package:flutter/material.dart';

class ConductQuizScreen extends StatefulWidget {
  final String defaultOption;
  const ConductQuizScreen({Key? key, required this.defaultOption}) : super(key: key);

  @override
  State<ConductQuizScreen> createState() => _ConductQuizScreenState();
}

class _ConductQuizScreenState extends State<ConductQuizScreen> {
  List<String> options = ['Array', 'String', 'LinkedList', 'Tree',
    'Graph', 'Stack', 'Queue', 'DP',
    'Backtracking','Recursion'];
  String? selectedValue;
  
  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select an Option")),
      body: Container(
        width:double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 39, 32, 90),
           Color.fromARGB(255, 48, 46, 86),
           Color.fromARGB(255, 7, 12, 34)],
          )
        ),
        child: SingleChildScrollView(
          child: Center(
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                    
                  });
                }
              },
              items: options.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                  
                ); 
              }).toList(),
            ),
          ),
        ),
      ),
    );  
  }
}