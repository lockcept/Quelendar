import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/quest.dart';
import 'package:quelendar/quest_provider.dart';
import 'package:quelendar/util/card_table.dart';

class MissionEditView extends StatefulWidget {
  final String missionId;
  const MissionEditView({required this.missionId, super.key});

  @override
  MissionEditViewState createState() => MissionEditViewState();
}

class MissionEditViewState extends State<MissionEditView> {
  late int startAt;
  late int? endAt;
  late int goal;

  bool isEditMode = false;

  void setEditState() {
    final mission = context.read<QuestProvider>().missionMap[widget.missionId];

    startAt = mission?.startAt ?? DateTime.now().millisecondsSinceEpoch;
    endAt = mission?.endAt;
    goal = mission?.goal ?? 0;
  }

  @override
  void initState() {
    super.initState();
    setEditState();
  }

  String? validateQuest() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();
    final Mission? mission = questProvider.missionMap[widget.missionId];

    final List<Widget> listViewChildren = (() {
      if (mission == null) return [Container()];
      if (isEditMode) {
        return [
          CardTable(data: {
            '이름': TextFormField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (text) {
                setState(() {});
              },
              initialValue: mission.id,
              decoration: const InputDecoration(
                hintText: "퀘스트의 이름을 입력하세요",
              ),
              keyboardType: TextInputType.text,
            ),
          }),
        ];
      } else {
        return [
          CardTable(
            data: {
              '아이디': Text(
                mission.id,
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
          if (!isEditMode && mission != null)
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => setState(() {
                setEditState();
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
