import 'package:flutter/material.dart';
import '../models/questions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';

class DailyQuestionScreen extends StatefulWidget {
  const DailyQuestionScreen({Key? key}) : super(key: key);

  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  Question? _question;
  bool _isLoading = true;
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    fetchDailyQuestion()
        .then((value) {
          setState(() {
            _question = value;
            debugPrint('Question fetched successfully: ${_question!.question}');
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🔥:25")),
      backgroundColor: Color.fromARGB(255, 153, 167, 204),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 39, 32, 90), Color.fromARGB(255, 70, 66, 128), Color.fromARGB(255, 45, 29, 120)],
          ),
        ),
        padding: EdgeInsets.all(16),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _question == null
                ? Center(
                  child: Text(
                    'Failed to Load question',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 0),
                    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.01), // semi-transparent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _question!.question,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),
                          ...List.generate(_question!.options.length, (index) {
                            Color bgColor = const Color.fromARGB(88, 82, 77, 77);
                            if (selectedIndex != -1) {
                              final selectedText = _question!.options[selectedIndex];
                              if (_question!.options[index] ==
                                  _question!.correctOption){
                                bgColor = Colors.green;}
                              else if (_question!.options[index] == selectedText){
                                bgColor = Colors.red;}
                            }
                      
                            return GestureDetector(
                              onTap:
                                  selectedIndex == -1
                                      ? () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      }
                                      : null,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  _question!.options[index],
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}

Future<Question> fetchDailyQuestion() async {
  final response = await http.get(
    Uri.parse('http://192.168.29.61:3000/candidate/daily-question'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final q = data['question'];

    // Compute correctIndex from correct_option string
    final correctOption = q['correct_option'];
    final options = List<String>.from(q['options']);
    return Question(
      question: q['question'],
      options: options,
      correctOption: correctOption,
    );
  } else {
    throw Exception('Failed to load question');
  }
}
