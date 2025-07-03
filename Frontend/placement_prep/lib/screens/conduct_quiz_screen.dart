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
      body: Center(
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
    );  
  }
}