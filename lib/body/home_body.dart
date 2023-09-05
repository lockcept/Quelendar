import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/filter_view.dart';
import 'package:quelendar/item/mission_item.dart';
import 'package:quelendar/provider/preference_provider.dart';
import 'package:quelendar/provider/quest_provider.dart';
import 'package:quelendar/util/calculate_focus_color.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = context.watch<PreferenceProvider>();

    final nowTimestamp = Jiffy.now().millisecondsSinceEpoch;

    final missionList = context.watch<QuestProvider>().missionMap.values.toList();
    missionList.sort((a, b) => -a.endAt.compareTo(b.endAt));

    final questMap = context.watch<QuestProvider>().questMap;
    final tagMap = context.watch<QuestProvider>().tagMap;
    final questNameFilter = preferenceProvider.questNameFilter;
    final tagNameFilter = preferenceProvider.tagNameFilter;

    final filteredMissionList = missionList.where((mission) {
      final quest = questMap[mission.questId];
      if (quest == null) return false;

      if (questNameFilter != null) {
        if (!quest.name.contains(questNameFilter)) return false;
      }
      if (tagNameFilter != null) {
        final tagNameList = quest.tagIdList.map((tagId) => tagMap[tagId]?.name ?? "").toList();
        if (!tagNameList.contains(tagNameFilter)) return false;
      }
      return true;
    }).toList();

    final currMissionList = filteredMissionList
        .where((mission) => mission.startAt <= nowTimestamp && nowTimestamp < mission.endAt)
        .toList();
    final prevMissionList = filteredMissionList
        .where((mission) => nowTimestamp - 7 * 24 * 60 * 60 * 1000 < mission.endAt && mission.endAt <= nowTimestamp)
        .toList();

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
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const Center(
              child: Text(
                '진행 중',
                textScaleFactor: 1.6,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Card(
              elevation: 2.0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ...currMissionList.map((mission) => MissionItem(missionId: mission.id)).toList(),
                    if (currMissionList.isEmpty) const Center(child: Text('진행 중인 미션이 없습니다'))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Center(
              child: Text(
                '최근에 완료',
                textScaleFactor: 1.6,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Card(
              elevation: 2.0,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ...prevMissionList.map((mission) => MissionItem(missionId: mission.id)).toList(),
                    if (prevMissionList.isEmpty) const Center(child: Text('완료된 미션이 없습니다'))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
