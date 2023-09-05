import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/item/task_edit_view.dart';
import 'package:quelendar/provider/quest_provider.dart';

class TaskItem extends StatelessWidget {
  final String taskId;
  const TaskItem({required this.taskId, super.key});

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();

    final task = questProvider.taskMap[taskId];
    if (task == null) return Container();

    final mission = questProvider.missionMap[task.missionId];
    if (mission == null) return Container();

    final quest = questProvider.questMap[mission.questId];
    if (quest == null) return Container();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        color: Theme.of(context).cardTheme.color,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(task.name),
          trailing: Text(
            "${task.value}",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskEditView(taskId: taskId)),
            );
          },
        ),
      ),
    );
  }
}
