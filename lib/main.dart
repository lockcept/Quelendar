import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/quelendar.dart';
import 'package:quelendar/quest_provider.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF40F909), brightness: Brightness.light),
        fontFamily: "NotoSansKr",
      ),
      home: const Quelendar(),
    );
  }
}
