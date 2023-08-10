import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_provider.dart';

class QuestItem extends StatelessWidget {
  final Quest quest;
  const QuestItem({required this.quest, super.key});

  @override
  Widget build(BuildContext context) {
    final tagMap = context.watch<QuestProvider>().tagMap;
    final tagNameList = quest.tagIdList.map((String id) {
      final tag = tagMap[id];
      if (tag != null) return "#${tag.name}";
    });
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 10.0),
          )
        ],
      ),
      child: Card(
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          title: Text(
            quest.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(tagNameList.join((", "))),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestEditView(quest: quest)),
            );
          },
        ),
      ),
    );
  }
}

class QuestEditView extends StatelessWidget {
  final Quest quest;
  const QuestEditView({required this.quest, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            quest.name = "asdf";
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
