import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/item/quest_item.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_provider.dart';
import 'package:quest_tracker/util/card_table.dart';
import 'package:quest_tracker/util/get_format_string.dart';

class QuestEditView extends StatefulWidget {
  final Quest? quest;
  const QuestEditView({this.quest, super.key});

  @override
  QuestEditViewState createState() => QuestEditViewState();
}

class QuestEditViewState extends State<QuestEditView> {
  bool isEditMode = false;
  late String id;
  late String name;
  late List<String> tagIdList;
  late int startAt;
  late int? endAt;
  late RepeatCycle repeatCycle;
  late List<int> repeatData;
  late AchievementType achievementType;
  late int goal;

  late bool isFinite;

  @override
  void initState() {
    super.initState();

    id = widget.quest?.id ?? nanoid();
    name = widget.quest?.name ?? "";
    tagIdList = widget.quest?.tagIdList ?? [];
    startAt = widget.quest?.startAt ?? DateTime.now().millisecondsSinceEpoch;
    endAt = widget.quest?.endAt;
    repeatCycle = widget.quest?.repeatCycle ?? RepeatCycle.none;
    repeatData = widget.quest?.repeatData ?? [];
    achievementType = widget.quest?.achievementType ?? AchievementType.count;
    goal = widget.quest?.goal ?? 1;

    isFinite = endAt != null;

    log(startAt.toString());
  }

  String? validateQuest() {
    if (name.isEmpty) return "이름을 입력하세요";
    if (name.length > 16) return "이름은 16글자를 넘을 수 없습니다";
    if (tagIdList.length > 3) return "태그는 최대 3개까지 지정 가능합니다";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tagMap = context.watch<QuestProvider>().tagMap;
    final tagNameList = tagIdList.map((String id) {
      final tag = tagMap[id];
      if (tag != null) return "#${tag.name}";
    });
    final missionMap = context.watch<QuestProvider>().missionMap;
    final missionList =
        missionMap.values.where((mission) => mission.questId == id).toList();

    final viewModeChildren = [
      CardTable(
        data: {
          '이름': Text(
            name.toString(),
          ),
          '태그': Text(
            tagNameList.join(", "),
          ),
        },
      ),
      CardTable(
        data: {
          '시작 날짜': Text(getDateformatString(startAt)),
          '종료 날짜': Text(endAt != null ? getDateformatString(endAt!) : "없음"),
          '반복 주기': Text(getRepeatMessage(repeatCycle, repeatData) ?? ""),
        },
      ),
      CardTable(data: {
        '달성 목표': Text(getGoalMessage(achievementType, goal)),
        '미션 리스트': Text(missionList.toString()),
      }),
    ];

    final List<Widget> editModeChildren = [
      CardTable(data: {
        '이름': TextFormField(
          onChanged: (text) {
            setState(() {
              name = text;
            });
          },
          initialValue: name,
          decoration: const InputDecoration(
            hintText: "퀘스트의 이름을 입력하세요",
          ),
          keyboardType: TextInputType.text,
        ),
        '태그': TextFormField(),
      }),
      CardTable(data: {
        '시작 날짜': ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer)),
          onPressed: () async {
            final startDate = DateTime.fromMillisecondsSinceEpoch(startAt);

            final maxDate = DateTime(2033).subtract(const Duration(days: 1));

            final endDate = endAt != null
                ? DateTime.fromMillisecondsSinceEpoch(endAt!)
                : maxDate;

            final lastDate = maxDate.isAfter(endDate) ? endDate : maxDate;

            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: startDate,
              firstDate: DateTime(2023),
              lastDate: lastDate,
            );

            if (pickedDate != null) {
              setState(() {
                startAt = pickedDate.millisecondsSinceEpoch;
              });
            }
          },
          child: Text(getDateformatString(startAt)),
        ),
        '종료 날짜': Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: isFinite ? "있음" : "없음",
              onChanged: (value) {
                setState(() {
                  if (value == "있음") {
                    isFinite = true;
                  } else {
                    isFinite = false;
                  }
                });
              },
              items: <String>['있음', '없음']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            if (isFinite)
              Container(margin: const EdgeInsets.symmetric(vertical: 10)),
            if (isFinite)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: endAt != null
                        ? DateTime.fromMillisecondsSinceEpoch(endAt!)
                        : DateTime.now(),
                    firstDate: DateTime.fromMillisecondsSinceEpoch(startAt),
                    lastDate: DateTime(2033).subtract(const Duration(days: 1)),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      endAt = pickedDate.millisecondsSinceEpoch;
                    });
                  }
                },
                child: Text(
                    endAt != null ? getDateformatString(endAt!) : "종료 날짜 설정"),
              ),
          ],
        ),
        '반복 주기': TextFormField(),
      }),
      CardTable(data: {
        '달성 목표': TextFormField(),
      }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onTertiary)),
          onPressed: () {
            final validation = validateQuest();

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
              final quest = Quest(
                id: id,
                name: name,
                tagIdList: tagIdList,
                startAt: startAt,
                endAt: endAt,
                repeatCycle: repeatCycle,
                repeatData: repeatData,
                achievementType: achievementType,
                goal: goal,
              );

              context.watch<QuestProvider>().addQuest(quest);
              setState(() {
                isEditMode = false;
              });
            } catch (e) {
              log("failed to update quest", error: e);
            }
          },
          child: const Text('저장', style: TextStyle(color: Colors.white)),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀘스트 관리'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isEditMode)
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () => setState(() {
                isEditMode = true;
              }),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: isEditMode ? editModeChildren : viewModeChildren,
        ),
      ),
    );
  }
}
