import 'package:flutter/material.dart';
import 'package:placement_prep/models/questions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final String topic;
  final int count;

  QuizScreen({Key? key, required this.topic, required this.count})
    : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  List<int?> selectedAnswers = [];
  int currentIndex = 0;
  bool isLoading = true;
  bool generated = false;
  bool quizStarted = false;
  int seconds = 0;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  String formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  Future<List<Question>> fetchMCQs(String topic, int count) async {
    debugPrint("came to collecting response");
    final response = await http.get(
      Uri.parse(
        'http://192.168.29.61:3000/candidate/generate-quiz?topic=$topic&count=$count',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> mcqList = jsonData['mcqs'];
      return mcqList.map((item) => Question.fromJson(item)).toList();
    } else {
      setState(() {
        isLoading = false;
        generated = true;
      });
      throw Exception('Failed to load questions');
    }
  }

  Future<void> loadQuestions() async {
    debugPrint("Before fetching questions");
    final fetched = await fetchMCQs(widget.topic, widget.count);
    setState(() {
      questions = fetched;
      selectedAnswers = List<int?>.filled(fetched.length, null);
      isLoading = false;
      generated = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (!quizStarted) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 39, 32, 90),
              Color.fromARGB(255, 48, 46, 86),
              Color.fromARGB(255, 7, 12, 34),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/animation/Generating.json',
                width: screenWidth * .8,
                height: screenHeight * 0.4,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  isLoading
                      ? 'Please wait! We are generating your quiz...'
                      : '✅ Quiz is ready! Press Start to begin.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(235, 255, 255, 255),
                    ),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!isLoading)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      quizStarted = true;
                      startTimer();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Start Quiz",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentIndex];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        bool exitConfirmed = await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Exit Quiz?"),
                content: const Text(
                  "Are you sure you want to leave the quiz? Your progress will be lost.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // Stay
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (Route<dynamic> route) =>
                            false, // remove all previous routes
                      );
                    },
                    child: const Text("Yes, Exit"),
                  ),
                ],
              ),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        backgroundColor: const Color.fromARGB(255, 153, 167, 204),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 39, 32, 90),
                Color.fromARGB(255, 48, 46, 86),
                Color.fromARGB(255, 7, 12, 34),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ).withOpacity(0.01),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Question ${currentIndex + 1} of ${questions.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(formatTime(seconds)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(question.options.length, (index) {
                      Color bgColor = const Color.fromARGB(88, 82, 77, 77);
                      if (selectedAnswers[currentIndex] != null) {
                        if (index == selectedAnswers[currentIndex]) {
                          bgColor = Colors.blueAccent.withOpacity(0.7);
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswers[currentIndex] = index;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            question.options[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentIndex > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentIndex--;
                              });
                            },
                            child: const Text('Previous'),
                          ),
                        if (currentIndex < questions.length - 1)
                          ElevatedButton(
                            onPressed:
                                selectedAnswers[currentIndex] == null
                                    ? null
                                    : () {
                                      setState(() {
                                        currentIndex++;
                                      });
                                    },
                            child: const Text('Next'),
                          ),
                        if (currentIndex == questions.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              int score = 0;
                              for (int i = 0; i < questions.length; i++) {
                                if (selectedAnswers[i] != null &&
                                    questions[i].options[selectedAnswers[i]!] ==
                                        questions[i].correctOption) {
                                  score++;
                                }
                              }
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Quiz Completed'),
                                      content: Text(
                                        'You have answered all questions! your final score is $score',
                                      ),

                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => {
                                                Navigator.of(context).pop(),
                                                Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/home',
                                                  (Route<dynamic> route) =>
                                                      false, // remove all previous routes
                                                ),
                                              },

                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: const Text('Submit'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
