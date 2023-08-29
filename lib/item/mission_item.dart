import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/mission_edit_view.dart';
import 'package:quelendar/quest_provider.dart';

class MissionItem extends StatelessWidget {
  final String missionId;
  const MissionItem({required this.missionId, super.key});

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();

    final mission = questProvider.missionMap[missionId];
    if (mission == null) return Container();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          title: const Text(
            "날짜",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("몇 번째"),
          ),
          trailing: Text(
            "달성도",
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
