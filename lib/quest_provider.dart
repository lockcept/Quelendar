import 'package:flutter/material.dart';
import 'package:quest_tracker/quest.dart';
import 'package:quest_tracker/quest_dummy.dart';
import 'package:quest_tracker/util/random_id.dart';

class QuestProvider with ChangeNotifier {
  Map<String, Quest> questMap = {};
  Map<String, Mission> missionMap = {};
  Map<String, Task> taskMap = {};
  Map<String, Tag> tagMap = {};

  QuestProvider() {
    insertDummy();
  }

  void insertDummy() {
    void addTag(Tag tag) {
      tagMap[tag.id] = tag;
    }

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

  Tag getTagByName(String tagName) {
    return tagMap.values.firstWhere((Tag t) {
      return t.name == tagName;
    }, orElse: () {
      final newTag = Tag(id: randomId(), name: tagName);
      tagMap[newTag.id] = newTag;
      return newTag;
    });
  }
}
