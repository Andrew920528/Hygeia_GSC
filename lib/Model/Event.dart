import 'package:flutter/material.dart';
class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  String location;
  final Color themeColor;
  // Duration duration;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location = "unspecified",
    this.themeColor = Colors.blue,
  });
}
