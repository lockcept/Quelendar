import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/filter_view.dart';
import 'package:quelendar/item/quest_edit_view.dart';
import 'package:quelendar/item/quest_item.dart';
import 'package:quelendar/provider/preference_provider.dart';
import 'package:quelendar/provider/quest_provider.dart';
import 'package:quelendar/util/calculate_focus_color.dart';

class QuestBody extends StatelessWidget {
  const QuestBody({super.key});

  @override
  Widget build(BuildContext context) {
    final questMap = context.watch<QuestProvider>().questMap;
    final tagMap = context.watch<QuestProvider>().tagMap;
    final preferenceProvider = context.watch<PreferenceProvider>();

    final questNameFilter = preferenceProvider.questNameFilter;
    final tagNameFilter = preferenceProvider.tagNameFilter;

    final filteredQuestList = questMap.values.where((quest) {
      if (questNameFilter != null) {
        if (!quest.name.contains(questNameFilter)) return false;
      }
      if (tagNameFilter != null) {
        final tagNameList = quest.tagIdList.map((tagId) => tagMap[tagId]?.name ?? "").toList();
        if (!tagNameList.contains(tagNameFilter)) return false;
      }
      return true;
    }).toList();

    final itemCount = filteredQuestList.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            color: preferenceProvider.isFilterEnable
                ? calculateFocusColor(Theme.of(context).colorScheme.primary)
                : Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterView(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestEditView.generateQuest(),
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
                return QuestItem(questId: filteredQuestList[index].id);
              },
            )
          : const Center(child: Text('퀘스트를 생성해보세요.')),
    );
  }
}
