import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/quest.dart';
import 'package:quelendar/quest_provider.dart';
import 'package:quelendar/util/card_table.dart';
import 'package:quelendar/util/get_format_string.dart';
import 'package:quelendar/util/number_scroll_row.dart';
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
  late List<int> startAtList;
  late List<int>? endAtList;
  late int value;
  late String name;

  late bool isFinished;
  bool isEditMode = false;
  late bool isGenerateMode;

  void setValueAuto() {
    if (endAtList == null) {
      value = 0;
      return;
    }

    final mission = context.read<QuestProvider>().missionMap[missionId];
    if (mission == null) return;

    final quest = context.read<QuestProvider>().questMap[mission.questId];
    if (quest == null) return;

    if (quest.achievementType == AchievementType.minute) {
      final startAt = Jiffy.parseFromList(startAtList).millisecondsSinceEpoch;
      final endAt = Jiffy.parseFromList(endAtList!).millisecondsSinceEpoch;
      value = (endAt - startAt) ~/ (60 * 1000);
    }
  }

  void setEditState() {
    final task = context.read<QuestProvider>().taskMap[widget.taskId];
    if (isGenerateMode) {
      isEditMode = true;
      taskId = widget.taskId;
      missionId = widget.missionId ?? "";
      startAtList = getListFromTimestamp(Jiffy.now().millisecondsSinceEpoch);
      endAtList = null;
      value = 0;
      name = "";

      isFinished = false;

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
      startAtList = getListFromTimestamp(task.startAt);
      value = task.value;
      name = task.name;
      isFinished = true;

      if (task.endAt != null) {
        endAtList = getListFromTimestamp(task.endAt!);
      } else {
        // 진행 중
        endAtList = getListFromTimestamp(Jiffy.now().millisecondsSinceEpoch);
        isEditMode = true;

        setValueAuto();
      }
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
    if (Jiffy.parseFromList(startAtList).millisecondsSinceEpoch >
        Jiffy.parseFromList(endAtList ?? startAtList).millisecondsSinceEpoch) return "완료 시각이 시작 시각보다 이를 수 없습니다";
    if (value < 0) return "달성도는 0보다 작을 수 없습니다";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();
    final Task? task = questProvider.taskMap[widget.taskId];
    final Mission? mission = questProvider.missionMap[missionId];
    if (mission == null) return Container();

    final Quest? quest = questProvider.questMap[mission.questId];
    if (quest == null) return Container();

    final List<Widget> listViewChildren = (() {
      if (isEditMode) {
        final isValueEnable = quest.achievementType != AchievementType.minute && isFinished;
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
          CardTable(data: {
            '시작 날짜': ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              onPressed: () async {
                final initialDate = Jiffy.parseFromList(startAtList).dateTime;

                final startDate = DateTime(2023);

                final endDate = DateTime(2123).subtract(const Duration(days: 1));

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: startDate,
                  lastDate: endDate,
                );

                if (pickedDate != null) {
                  setState(() {
                    final list = getListFromTimestamp(pickedDate.millisecondsSinceEpoch);
                    startAtList[0] = list[0];
                    startAtList[1] = list[1];
                    startAtList[2] = list[2];
                    setValueAuto();
                  });
                }
              },
              child: Text(getDateformatString(Jiffy.parseFromList(startAtList).millisecondsSinceEpoch)),
            ),
            '시작 시각': Row(
              children: [
                Expanded(
                  flex: 5,
                  child: NumberScrollRow(
                    defaultValue: startAtList[3],
                    onChanged: (value) => setState(() {
                      startAtList[3] = value;
                      setValueAuto();
                    }),
                    trailingText: '시',
                    maxValue: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: NumberScrollRow(
                    defaultValue: startAtList[4],
                    onChanged: (value) => setState(() {
                      startAtList[4] = value;
                      setValueAuto();
                    }),
                    trailingText: '분',
                    maxValue: 59,
                  ),
                )
              ],
            )
          }),
          CardTable(data: {
            '완료하기': DropdownButton<String>(
              value: isFinished ? "완료" : "진행 중",
              onChanged: (value) {
                setState(() {
                  if (value == "완료") {
                    isFinished = true;
                    endAtList ??= getListFromTimestamp(Jiffy.now().millisecondsSinceEpoch);
                  } else {
                    isFinished = false;
                    endAtList = null;
                  }
                  setValueAuto();
                });
              },
              items: <String>['완료', '진행 중']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            if (isFinished && endAtList != null)
              '완료 날짜': ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                onPressed: () async {
                  final initialDate = Jiffy.parseFromList(endAtList ?? startAtList).dateTime;

                  final startDate = DateTime(2023);

                  final endDate = DateTime(2123).subtract(const Duration(days: 1));

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: startDate,
                    lastDate: endDate,
                  );

                  if (pickedDate != null) {
                    setState(() {
                      final list = getListFromTimestamp(pickedDate.millisecondsSinceEpoch);
                      endAtList?[0] = list[0];
                      endAtList?[1] = list[1];
                      endAtList?[2] = list[2];
                      setValueAuto();
                    });
                  }
                },
                child: Text(getDateformatString(Jiffy.parseFromList(endAtList!).millisecondsSinceEpoch)),
              ),
            if (isFinished && endAtList != null)
              '완료 시각': Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: NumberScrollRow(
                      defaultValue: endAtList![3],
                      onChanged: (value) => setState(() {
                        endAtList![3] = value;
                        setValueAuto();
                      }),
                      trailingText: '시',
                      maxValue: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: NumberScrollRow(
                      defaultValue: endAtList![4],
                      onChanged: (value) => setState(() {
                        endAtList![4] = value;
                        setValueAuto();
                      }),
                      trailingText: '분',
                      maxValue: 59,
                    ),
                  )
                ],
              )
          }),
          CardTable(data: {
            '달성도 (${quest.achievementType.label})': TextFormField(
              key: isValueEnable ? null :  GlobalKey(debugLabel: value.toString()),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (input) {
                final number = int.tryParse(input) ?? 0;
                if (number == value) return;

                setState(() {
                  value = number;
                });
              },
              keyboardType: TextInputType.number,
              initialValue: value.toString(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: isValueEnable,
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
                    startAt: Jiffy.parseFromList(startAtList).millisecondsSinceEpoch,
                    endAt: endAtList != null ? Jiffy.parseFromList(endAtList!).millisecondsSinceEpoch : null,
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
              '이름': Text(
                task.name,
                textScaleFactor: 1.3,
              ),
            },
          ),
          CardTable(
            data: {
              '시작': Text(getDateformatString(task.startAt, detail: true)),
              '종료': Text(task.endAt != null ? getDateformatString(task.endAt!, detail: true) : "진행 중"),
            },
          ),
          CardTable(
            data: {
              '달성도': Text(task.value.toString()),
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
          if (!isEditMode && !isGenerateMode)
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
          if (isEditMode && !isGenerateMode)
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
