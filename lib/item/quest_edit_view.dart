import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_provider.dart';
import 'package:quest_tracker/util/get_dateformat_string.dart';
import 'package:quest_tracker/util/get_devided_row.dart';

class QuestEditView extends StatefulWidget {
  final Quest? quest;
  const QuestEditView({this.quest, super.key});

  @override
  QuestEditViewState createState() => QuestEditViewState();
}

class QuestEditViewState extends State<QuestEditView> {
  bool isEditMode = false;
  late String id;
  String? name;
  List<String> tagIdList = [];
  int? startAt;
  int? endAt;
  RepeatCycle? repeatCycle;
  List<int> repeatData = [];
  AchievementType? achievementType;
  int? goal;

  @override
  void initState() {
    super.initState();

    id = widget.quest?.id ?? nanoid();
    name = widget.quest?.name;
    startAt = widget.quest?.startAt;
    log(startAt.toString());
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) return "이름을 입력하세요";
    return null;
  }

  bool isStartAtValid() {
    if (startAt == null) return false;
    return true;
  }

  bool isRepeatCycleValid() {
    if (repeatCycle == null) return false;
    return true;
  }

  bool isAchievementTypeValid() {
    if (achievementType == null) return false;
    return true;
  }

  bool isGoalValid() {
    if (goal == null) return false;
    return true;
  }

  String? validateQuest() {
    return validateName(name);
  }

  @override
  Widget build(BuildContext context) {
    final viewModeChildren = [
      getDevidedRow(
        '이름',
        Text(
          name.toString(),
        ),
      ),
      getDevidedRow(
        '태그',
        Text(
          tagIdList.toString(),
        ),
      ),
      getDevidedRow(
        '시작 날짜',
        Text(getDateformatString(startAt) ?? "시작 날짜가 없습니다."),
      ),
      getDevidedRow(
        '종료 날짜',
        Text(getDateformatString(endAt) ?? "종료 날짜가 없습니다."),
      ),
      getDevidedRow(
        '반복 주기',
        TextFormField(),
      ),
      getDevidedRow(
        '달성 목표',
        TextFormField(),
      ),
    ];
    final editModeChildren = [
      getDevidedRow(
        '이름',
        TextFormField(
          onChanged: (text) {
            setState(() {
              name = text;
            });
          },
          initialValue: name,
          decoration: const InputDecoration(hintText: "퀘스트의 이름을 입력하세요"),
          keyboardType: TextInputType.text,
        ),
      ),
      getDevidedRow(
        '태그',
        TextFormField(),
      ),
      getDevidedRow(
        '시작 날짜',
        TextFormField(),
      ),
      getDevidedRow(
        '종료 날짜',
        TextFormField(),
      ),
      getDevidedRow(
        '반복 주기',
        TextFormField(),
      ),
      getDevidedRow(
        '달성 목표',
        TextFormField(),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            final validation = validateQuest();
            log(name.toString());
            log(validation.toString());

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
                name: name!,
                tagIdList: tagIdList,
                startAt: startAt!,
                endAt: endAt,
                repeatCycle: repeatCycle!,
                repeatData: repeatData,
                achievementType: achievementType!,
                goal: goal!,
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isEditMode)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
