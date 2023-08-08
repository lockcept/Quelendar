import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/item/quest_item.dart';
import 'package:quest_tracker/quest_provider.dart';

class QuestBody extends StatelessWidget {
  const QuestBody({super.key});

  @override
  Widget build(BuildContext context) {
    var questList = context.watch<QuestProvider>().questList;
    log(questList.toString());

    var itemCount = questList.length;

    return Scaffold(
      appBar: AppBar(title: const Text('오른쪽에 검색과 정렬이 들어가야함')),
      body: itemCount > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return QuestItem(quest: questList[index]);
              },
            )
          : const Center(child: Text('퀘스트를 생성해보세요.')),
    );
  }
}
