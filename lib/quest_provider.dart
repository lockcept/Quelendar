import 'package:flutter/material.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_dummy.dart';

class QuestProvider with ChangeNotifier {
  Map<String, Quest> questMap = {};
  Map<String, Mission> missionMap = {};
  Map<String, Task> taskMap = {};
  Map<String, Tag> tagMap = {};

  QuestProvider() {
    insertDummy();
  }

  void insertDummy() {
    addQuest(quest1);
    addQuest(quest2);
    addQuest(quest3);
    addQuest(quest4);
    addTag(tag1);
    addTag(tag2);
    notifyListeners();
  }

  void addQuest(Quest quest) {
    questMap[quest.id] = quest;
    notifyListeners();
  }

  void addTag(Tag tag) {
    tagMap[tag.id] = tag;
    notifyListeners();
  }
}
