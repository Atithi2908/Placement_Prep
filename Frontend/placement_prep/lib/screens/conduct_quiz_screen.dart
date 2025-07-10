import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:placement_prep/screens/quiz_screen.dart';

class ConductQuizScreen extends StatefulWidget {
  final String defaultOption;
  const ConductQuizScreen({Key? key, required this.defaultOption})
    : super(key: key);

  @override
  State<ConductQuizScreen> createState() => _ConductQuizScreenState();
}

class _ConductQuizScreenState extends State<ConductQuizScreen> {
  List<String> options = [
    'Array',
    'String',
    'LinkedList',
    'Tree',
    'Graph',
    'Stack',
    'Queue',
    'DP',
    'Recursion',
    'Heap',
  ];
  String? selectedValue;
  int? selectedNumQuestions = 5;
  bool fairPracticeChecked = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Select an Option")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 39, 32, 90),
              Color.fromARGB(255, 48, 46, 86),
              Color.fromARGB(255, 7, 12, 34),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                  SizedBox(height: screenHeight * 0.05),
                Text(
                  "Generate your Ai-Powered Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
               

                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select a Topic",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
 
                Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 89, 81, 152),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Color.fromARGB(255, 89, 81, 152),
                    value: selectedValue,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    isExpanded: true, // Ensures text uses full width
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      }
                    },
                    items:
                        options.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                  ),
                ),

               SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Number of Questions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 89, 81, 152),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: DropdownButton<int>(
                    dropdownColor: Color.fromARGB(255, 89, 81, 152),
                    value: selectedNumQuestions,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedNumQuestions = newValue;
                        });
                      }
                    },
                    items: [5, 10].map((int item) {
                      return DropdownMenuItem<int>(
                        value: item,
                        child: Text(item.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: fairPracticeChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          fairPracticeChecked = value ?? false;
                        });
                      },
                      activeColor: Color.fromARGB(188, 20, 159, 252),
                      checkColor: Colors.white,
                    ),
                    Flexible(
                      child: Text(
                        " I will not engage in any form of malpractice while attempting this quiz.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: fairPracticeChecked
                      ? () {
                          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              topic: selectedValue ?? 'Array',
              count: selectedNumQuestions ?? 5,
            ),
          ),
        );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please agree before trying again.'),
                              backgroundColor: const Color.fromARGB(255, 48, 59, 143),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(188, 20, 159, 252),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  child: Text(
                    "Start Quiz",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
