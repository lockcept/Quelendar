import 'package:flutter/material.dart';

class QuestTracker extends StatefulWidget {
  const QuestTracker({super.key});

  @override
  _QuestTrackerState createState() => _QuestTrackerState();
}

class _QuestTrackerState extends State<QuestTracker> {
  // Add your quest tracker logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Tracker'),
      ),
      body: const Center(
        child: Text('Quest Tracker Content'),
      ),
    );
  }
}
