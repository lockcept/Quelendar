import 'package:flutter/material.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_dummy.dart';

class QuestProvider with ChangeNotifier {
  List<Quest> questList = [];
  List<Mission> missionList = [];
  List<Task> taskList = [];
  List<Tag> tagList = [];

  QuestProvider() {
    initQuest();
  }

  void initQuest() {
    questList.add(quest1);
    questList.add(quest2);
    questList.add(quest3);
    notifyListeners();
  }

  void addQuest(Quest quest) {
    questList.add(quest);
    notifyListeners();
  }
}
