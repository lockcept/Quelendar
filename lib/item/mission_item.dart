import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/mission_edit_view.dart';
import 'package:quelendar/provider/quest_provider.dart';
import 'package:quelendar/util/get_format_string.dart';

class MissionItem extends StatelessWidget {
  final String missionId;
  final bool insideQuest;
  const MissionItem({required this.missionId, this.insideQuest = false, super.key});

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();

    final mission = questProvider.missionMap[missionId];
    if (mission == null) return Container();

    final quest = questProvider.questMap[mission.questId];
    if (quest == null) return Container();

    final missionMap = questProvider.missionMap;
    final missionList = missionMap.values.where((m) => m.questId == mission.questId).toList();
    missionList.sort((p, q) => p.startAt.compareTo(q.startAt));
    final index = missionList.indexOf(mission) + 1;

    final taskMap = questProvider.taskMap;
    final taskList = taskMap.values.where((task) => task.missionId == missionId).toList();

    final totalGoal = taskList.map((task) => task.value).fold(0, (a, b) => a + b);

    final comment = mission.comment;

    return Container(
      margin: EdgeInsets.symmetric(vertical: insideQuest ? 2.0 : 4.0),
      child: Card(
        color: insideQuest ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).cardTheme.color,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!insideQuest)
              Text(
                quest.name,
                textScaleFactor: 0.7,
              ),
            RichText(
              text: TextSpan(
                text: getDateRangeformatString(mission.startAt, mission.endAt),
                style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
                children: <TextSpan>[
                  TextSpan(text: ' ($index)', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                ],
              ),
            )
          ]),
          subtitle: (comment != null)
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(comment),
                )
              : null,
          trailing: Text(
            "$totalGoal/${mission.goal}",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MissionEditView(missionId: missionId)),
            );
          },
        ),
      ),
    );
  }
}
