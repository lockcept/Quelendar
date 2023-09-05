import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/provider/firebase_provider.dart';
import 'package:quelendar/util/card_table.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = context.watch<FirebaseProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: const Text("로그인"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          CardTable(data: {
            '이메일': ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("구현 중"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("로그인"),
            ),
            '구글': ElevatedButton(
                onPressed: () async {
                  await firebaseProvider.signInWithGoogle();
                },
                child: const Text("로그인"))
          }),
        ]),
      ),
    );
  }
}
