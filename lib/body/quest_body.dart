import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/item/quest_item.dart';
import 'package:quest_tracker/quest_provider.dart';

class QuestBody extends StatelessWidget {
  const QuestBody({super.key});

  @override
  Widget build(BuildContext context) {
    final questMap = context.watch<QuestProvider>().questMap;

    final itemCount = questMap.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: itemCount > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return QuestItem(quest: questMap.values.toList()[index]);
              },
            )
          : const Center(child: Text('퀘스트를 생성해보세요.')),
    );
  }
}
