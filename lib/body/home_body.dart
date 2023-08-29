import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/mission_item.dart';
import 'package:quelendar/quest_provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final nowTimestamp = Jiffy.now().millisecondsSinceEpoch;

    final missionList = context.watch<QuestProvider>().missionMap.values.toList();
    missionList.sort((a, b) => -a.endAt.compareTo(b.endAt));

    final currMissionList =
        missionList.where((mission) => mission.startAt <= nowTimestamp && nowTimestamp < mission.endAt).toList();
    final prevMissionList = missionList.where((mission) => mission.endAt <= nowTimestamp).toList().sublist(0, 10);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
                '완료',
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
