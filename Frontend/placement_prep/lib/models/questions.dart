import 'package:flutter/material.dart';
class Question {
  final String question;
  final List<String> options;
  final String correctOption;

  Question({
    required this.question,
    required this.options,
    required this.correctOption,
  });
}
