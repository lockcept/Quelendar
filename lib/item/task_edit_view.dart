import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/quest.dart';
import 'package:quelendar/quest_provider.dart';
import 'package:quelendar/util/card_table.dart';
import 'package:quelendar/util/random_id.dart';

class TaskEditView extends StatefulWidget {
  final String taskId;
  final String? missionId;
  final bool isGenerateMode;
  const TaskEditView({required this.taskId, super.key})
      : missionId = null,
        isGenerateMode = false;
  TaskEditView.generateTask({required this.missionId, super.key})
      : taskId = randomId(),
        isGenerateMode = true;

  @override
  TaskEditViewState createState() => TaskEditViewState();
}

class TaskEditViewState extends State<TaskEditView> {
  late String taskId;
  late String missionId;
  late int startAt;
  late int? endAt;
  late int value;
  late String name;

  bool isEditMode = false;
  late bool isGenerateMode;

  void setEditState() {
    final task = context.read<QuestProvider>().taskMap[widget.taskId];
    if (isGenerateMode) {
      isEditMode = true;
      taskId = widget.taskId;
      missionId = widget.missionId ?? "";
      startAt = 0;
      endAt = null;
      value = 0;
      name = "";

      // 태스크 생성
      final mission = context.read<QuestProvider>().missionMap[widget.missionId];
      if (mission == null) return;

      final quest = context.read<QuestProvider>().questMap[mission.questId];
      if (quest == null) return;

      name = "${quest.name}의 태스크";
    } else {
      // 기존에 있는 태스크
      if (task == null) return;

      taskId = widget.taskId;
      missionId = task.missionId;
      startAt = task.startAt;
      endAt = task.endAt;
      value = task.value;
      name = task.name;

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    isGenerateMode = widget.isGenerateMode;
    setEditState();
  }

  String? validateTask() {
    if (name.length > 24) return "이름은 24글자를 넘을 수 없습니다";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();
    final Task? task = questProvider.taskMap[widget.taskId];

    final List<Widget> listViewChildren = (() {
      if (isEditMode) {
        return [
          CardTable(data: {
            '이름': TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (text) {
                setState(() {
                  name = text;
                });
              },
              initialValue: name,
              decoration: const InputDecoration(
                hintText: "이름을 입력하세요",
              ),
              keyboardType: TextInputType.text,
            ),
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                final validation = validateTask();

                if (validation != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(validation),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                try {
                  final newTask = Task(
                    id: widget.taskId,
                    missionId: missionId,
                    startAt: startAt,
                    endAt: endAt,
                    value: value,
                    name: name,
                  );

                  questProvider.addTask(newTask);
                  setState(() {
                    isEditMode = false;
                  });
                } catch (e) {
                  log("failed to update task", error: e);
                }
              },
              child: Text('저장', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
        ];
      } else {
        if (task == null) return <Widget>[];

        return [
          CardTable(
            data: {
              '아이디': Text(
                task.id,
                textScaleFactor: 1.3,
              ),
            },
          ),
          CardTable(
            data: {
              '메모': Text(
                task.name,
              ),
            },
          ),
        ];
      }
    })();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: const Text("태스크"),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isEditMode)
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => setState(() {
                setEditState();
                isEditMode = true;
              }),
            ),
          if (isEditMode)
            IconButton(
              icon: const Icon(
                Icons.close,
              ),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => setState(() {
                isEditMode = false;
              }),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: listViewChildren),
      ),
    );
  }
}