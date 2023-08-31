import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/quest.dart';
import 'package:quelendar/quest_provider.dart';
import 'package:quelendar/util/card_table.dart';
import 'package:quelendar/util/get_format_string.dart';

class MissionEditView extends StatefulWidget {
  final String missionId;
  const MissionEditView({required this.missionId, super.key});

  @override
  MissionEditViewState createState() => MissionEditViewState();
}

class MissionEditViewState extends State<MissionEditView> {
  String? comment;

  bool isEditMode = false;

  void setEditState() {
    final mission = context.read<QuestProvider>().missionMap[widget.missionId];

    if (mission == null) return;

    comment = mission.comment;
  }

  @override
  void initState() {
    super.initState();
    setEditState();
  }

  String? validateMission() {
    if (comment != null && comment!.length > 16) return "메모는 16글자를 넘을 수 없습니다";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();
    final Mission? mission = questProvider.missionMap[widget.missionId];
    if (mission == null) return Container();

    final quest = questProvider.questMap[mission.questId];
    if (quest == null) return Container();

    final taskMap = questProvider.taskMap;
    final taskList = taskMap.values.where((task) => task.missionId == widget.missionId).toList();
    final totalGoal = taskList.map((task) => task.value).fold(0, (a, b) => a + b);

    final List<Widget> listViewChildren = (() {
      if (isEditMode) {
        return [
          CardTable(data: {
            '메모': TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
              initialValue: comment ?? "",
              decoration: const InputDecoration(
                hintText: "메모를 입력하세요",
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
                final validation = validateMission();

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
                  final newMission = Mission(
                    id: mission.id,
                    questId: mission.questId,
                    startAt: mission.startAt,
                    endAt: mission.endAt,
                    goal: mission.goal,
                    comment: comment,
                  );

                  questProvider.addMission(newMission);
                  setState(() {
                    isEditMode = false;
                  });
                } catch (e) {
                  log("failed to update mission", error: e);
                }
              },
              child: Text('저장', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
        ];
      } else {
        return [
          CardTable(
            data: {
              '퀘스트': Text(
                quest.name,
                textScaleFactor: 1.3,
              ),
            },
          ),
          CardTable(
            data: {
              '시작': Text(getDateformatString(mission.startAt)),
              '종료': Text(getDateformatString(mission.endAt)),
            },
          ),
          CardTable(
            data: {
              '목표': Text(mission.goal.toString()),
              '달성도': Text(totalGoal.toString()),
              '미션 수행': Text(totalGoal.toString()),
            },
          ),
          if (mission.comment != null)
            CardTable(
              data: {
                '메모': Text(
                  mission.comment ?? "",
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
        title: const Text("미션"),
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
