import 'package:flutter/material.dart';
import 'package:quest_tracker/quest.dart';

class QuestProvider with ChangeNotifier {
  List<Quest> quests = [];
  List<Mission> missions = [];
  List<Task> tasks = [];
  List<Tag> tags = [];
  int a = 3;

  void addQuest(Quest quest) {
    quests.add(quest);
    notifyListeners();
  }
}
