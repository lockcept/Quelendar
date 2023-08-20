import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:quest_tracker/item/quest_item.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_provider.dart';
import 'package:quest_tracker/util/card_table.dart';
import 'package:quest_tracker/util/days_selector.dart';
import 'package:quest_tracker/util/get_format_string.dart';
import 'package:quest_tracker/util/number_scroll_row.dart';

class QuestEditView extends StatefulWidget {
  final Quest? quest;
  const QuestEditView({this.quest, super.key});

  @override
  QuestEditViewState createState() => QuestEditViewState();
}

class QuestEditViewState extends State<QuestEditView> {
  late Quest? quest;

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
  late List<String> tagNameList;
  List<GlobalKey> tagNameFormKeyList = [];

  @override
  void initState() {
    super.initState();

    quest = widget.quest;

    id = quest?.id ?? nanoid();
    name = quest?.name ?? "";
    tagIdList = quest?.tagIdList ?? [];
    startAt = quest?.startAt ?? DateTime.now().millisecondsSinceEpoch;
    endAt = quest?.endAt;
    repeatCycle = quest?.repeatCycle ?? RepeatCycle.none;
    repeatData = quest?.repeatData ?? [];
    achievementType = quest?.achievementType ?? AchievementType.count;
    goal = quest?.goal ?? 1;

    isFinite = endAt != null;

    final tagMap = context.read<QuestProvider>().tagMap;
    tagNameList = tagIdList.map((String id) {
      final tag = tagMap[id];
      if (tag != null) return tag.name;
      return "";
    }).toList();
    tagNameFormKeyList = tagNameList.map((_) {
      return GlobalKey();
    }).toList();
  }

  String? validateQuest() {
    if (name.isEmpty) return "이름을 입력하세요";
    if (name.length > 16) return "이름은 16글자를 넘을 수 없습니다";
    if (tagIdList.length > 3) return "태그는 최대 3개까지 지정 가능합니다";
    if (tagIdList.length != tagIdList.toSet().length) return "중복된 태그가 있습니다";
    if (isFinite && endAt == null) return "종료 날짜를 선택해 주세요";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();

    final List<Widget> listViewChildren = (() {
      if (isEditMode) {
        return [
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
            '태그': Column(
              children: [
                ...List.generate(tagNameList.length, (index) {
                  log(tagNameList[index]);

                  return Row(
                    children: [
                      Expanded(
                        key: tagNameFormKeyList[index],
                        child: TextFormField(
                          initialValue: tagNameList[index],
                          onChanged: (text) {
                            setState(() {
                              tagNameList[index] = text;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            tagNameList.removeAt(index);
                            tagNameFormKeyList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                }),
                if (tagNameList.length < 3)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        tagNameList.add("");
                        tagNameFormKeyList.add(GlobalKey());
                      });
                    },
                  )
              ],
            ),
          }),
          CardTable(data: {
            '시작': ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
              onPressed: () async {
                final startDate = DateTime.fromMillisecondsSinceEpoch(startAt);

                final maxDate = DateTime(2033).subtract(const Duration(days: 1));

                final endDate = endAt != null ? DateTime.fromMillisecondsSinceEpoch(endAt!) : maxDate;

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
            '종료하기': DropdownButton<String>(
              value: isFinite ? "있음" : "없음",
              onChanged: (value) {
                setState(() {
                  if (value == "있음") {
                    isFinite = true;
                  } else {
                    isFinite = false;
                    endAt = null;
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
              "종료": ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: endAt != null ? DateTime.fromMillisecondsSinceEpoch(endAt!) : DateTime.now(),
                    firstDate: DateTime.fromMillisecondsSinceEpoch(startAt),
                    lastDate: DateTime(2033).subtract(const Duration(days: 1)),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      endAt = pickedDate.millisecondsSinceEpoch;
                    });
                  }
                },
                child: Text(endAt != null ? getDateformatString(endAt!) : "종료 날짜 설정"),
              ),
            '반복': DropdownButton<String>(
              value: repeatCycle.label,
              onChanged: (value) {
                setState(() {
                  if (value != repeatCycle.label) repeatData = [];
                  repeatCycle = RepeatCycle.getByLabel(value!);
                });
              },
              items: RepeatCycle.values
                  .map((value) {
                    return value.label;
                  })
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            if (repeatCycle != RepeatCycle.none)
              '반복 설정': () {
                final firstElement = repeatData.isNotEmpty ? repeatData[0] : null;
                switch (repeatCycle) {
                  case RepeatCycle.none:
                    return const Text("반복 없음");
                  case RepeatCycle.month:
                    return NumberScrollRow(
                      defaultValue: firstElement ?? 1,
                      onChanged: (value) => setState(() => repeatData = [value]),
                      trailingText: '일',
                      maxValue: 28,
                    );
                  case RepeatCycle.week:
                    return DaysSelector(
                      selectedIndices: repeatData,
                      onSelectionChanged: (selectedIndices) {
                        setState(() {
                          repeatData = List.from(selectedIndices);
                        });
                      },
                    );
                  case RepeatCycle.dayPerDays:
                    return NumberScrollRow(
                      defaultValue: firstElement ?? 1,
                      onChanged: (value) => setState(() => repeatData = [value]),
                      trailingText: '일 마다',
                      maxValue: 50,
                    );
                  case RepeatCycle.days:
                    return NumberScrollRow(
                      defaultValue: firstElement ?? 1,
                      onChanged: (value) => setState(() => repeatData = [value]),
                      trailingText: '일에 걸쳐',
                      maxValue: 50,
                    );
                }
              }()
          }),
          CardTable(data: {
            '달성 목표': Row(children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  onChanged: (value) {
                    final number = int.tryParse(value) ?? 0;
                    if (number == goal) return;

                    setState(() {
                      goal = number;
                    });
                  },
                  keyboardType: TextInputType.number,
                  initialValue: goal.toString(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  value: achievementType.label,
                  onChanged: (value) {
                    setState(() {
                      achievementType = AchievementType.getByLabel(value!);
                    });
                  },
                  items: AchievementType.values
                      .map((value) {
                        return value.label;
                      })
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ]),
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiary)),
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
      } else {
        if (quest == null) return <Widget>[];

        final Quest viewQuest = quest!;

        final tagMap = questProvider.tagMap;
        final tagNameList = tagIdList.map((String id) {
          final tag = tagMap[id];
          if (tag != null) return tag.name;
          return "";
        }).toList();

        final missionMap = questProvider.missionMap;
        final missionList = missionMap.values.where((mission) => mission.questId == viewQuest.id).toList();

        return [
          CardTable(
            data: {
              '이름': Text(
                viewQuest.name.toString(),
              ),
              '태그': Text(
                tagNameList.map((name) => '#$name').join(", "),
              ),
            },
          ),
          CardTable(
            data: {
              '시작': Text(getDateformatString(viewQuest.startAt)),
              '종료': Text(viewQuest.endAt != null ? getDateformatString(viewQuest.endAt!) : "없음"),
              '반복': Text(getRepeatMessage(viewQuest.repeatCycle, viewQuest.repeatData) ?? ""),
            },
          ),
          CardTable(data: {
            '목표': Text(getGoalMessage(viewQuest.achievementType, viewQuest.goal)),
            '미션': Text(missionList.toString()),
          }),
        ];
      }
    })();

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀘스트 관리'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
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
        child: ListView(children: listViewChildren),
      ),
    );
  }
}
