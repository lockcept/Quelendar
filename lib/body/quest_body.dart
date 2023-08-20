import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/item/quest_edit_view.dart';
import 'package:quest_tracker/item/quest_item.dart';
import 'package:quest_tracker/quest_provider.dart';
import 'package:quest_tracker/util/random_id.dart';

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestEditView(
                    questId: randomId(),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: itemCount > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return QuestItem(questId: questMap.values.toList()[index].id);
              },
            )
          : const Center(child: Text('퀘스트를 생성해보세요.')),
    );
  }
}
