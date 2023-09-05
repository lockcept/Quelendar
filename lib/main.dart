import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/firebase_options.dart';
import 'package:quelendar/provider/firebase_provider.dart';
import 'package:quelendar/provider/preference_provider.dart';
import 'package:quelendar/quelendar.dart';
import 'package:quelendar/provider/quest_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FirebaseProvider()),
      ChangeNotifierProvider(create: (_) => QuestProvider()),
      ChangeNotifierProvider(create: (_) => PreferenceProvider())
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = context.watch<PreferenceProvider>();
    final isDarkMode = preferenceProvider.isDarkMode;
    // ignore: unused_local_variable
    final firebaseProvider = context.read<FirebaseProvider>(); // firebaseProvider init을 위해서

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF40F909), brightness: isDarkMode ? Brightness.dark : Brightness.light),
        fontFamily: "NotoSansKr",
      ),
      home: const Quelendar(),
    );
  }
}
