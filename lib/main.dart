import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/quest_provider.dart';
import 'package:quest_tracker/quest_tracker.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => QuestProvider())],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: const QuestTracker(),
    );
  }
}
