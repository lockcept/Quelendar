import 'package:flutter/material.dart';

class QuestItem extends StatelessWidget {
  const QuestItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text('퀘스트 아이템'),
    );
  }
}
