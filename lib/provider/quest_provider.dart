import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:quelendar/provider/firebase_provider.dart';
import 'package:quelendar/quest.dart';
import 'package:quelendar/util/random_id.dart';

const oneDayInMs = 1 * 24 * 60 * 60 * 1000;

class QuestProvider with ChangeNotifier {
  FirebaseProvider? firebaseProvider;

  Map<String, Quest> questMap = {};
  Map<String, Mission> missionMap = {};
  Map<String, Task> taskMap = {};
  Map<String, Tag> tagMap = {};

  QuestProvider(this.firebaseProvider) {
    initData();
  }

  Future<void> initData() async {
    if (firebaseProvider == null) return;
    await firebaseProvider!.initData(questMap, missionMap, taskMap, tagMap);
    await validateMission();
    notifyListeners();
  }

  Future<void> validateMission() async {
    final missionListByQuest = groupBy(missionMap.values, (mission) => mission.questId);

    for (final quest in questMap.values) {
      final missionList = List<Mission>.from(missionListByQuest[quest.id] ?? <Mission>[]);
      missionList.sort((p, q) => p.startAt.compareTo(q.startAt));

      final repeatCycle = quest.repeatCycle;

      int? lastMissionStartAt;
      if (missionList.isNotEmpty) lastMissionStartAt = missionList.last.startAt;
      final now = DateTime.now().millisecondsSinceEpoch;
      final maxStartAt = min(now, quest.endAt ?? now);

      Future<void> generateMission(int Function(int? lastStartAt) getNextStartAt, int duration) async {
        while (true) {
          final nextMissionStartAt = getNextStartAt(lastMissionStartAt);
          if (nextMissionStartAt > maxStartAt) break;

          final newMission = Mission(
              id: randomId(),
              questId: quest.id,
              startAt: nextMissionStartAt,
              endAt: nextMissionStartAt + duration,
              goal: quest.goal);

          await addMission(newMission);
          lastMissionStartAt = nextMissionStartAt;
        }
      }

      switch (repeatCycle) {
        case RepeatCycle.none:
          final startAt = Jiffy.parseFromMillisecondsSinceEpoch(quest.startAt).startOf(Unit.day).millisecondsSinceEpoch;
          final endAt = Jiffy.parseFromMillisecondsSinceEpoch(quest.endAt ?? quest.startAt)
              .startOf(Unit.day)
              .millisecondsSinceEpoch; // none이면 항상 endAt이 있음
          if (missionList.isEmpty) {
            final newMission =
                Mission(id: randomId(), questId: quest.id, startAt: startAt, endAt: endAt, goal: quest.goal);
            await addMission(newMission);
          }
          break;
        case RepeatCycle.month:
          await generateMission((lastStartAt) {
            Jiffy result;
            Jiffy startTime =
                Jiffy.parseFromMillisecondsSinceEpoch(lastStartAt ?? (quest.startAt - oneDayInMs)).startOf(Unit.day);

            final day = quest.repeatData[0];

            if (startTime.daysInMonth < day) {
              result = Jiffy.parseFromList([startTime.year, startTime.month, day]);
            } else {
              int nextMonth = startTime.month + 1;
              int nextYear = startTime.year;

              if (nextMonth > 12) {
                nextMonth = 1;
                nextYear = nextYear + 1;
              }
              result = Jiffy.parseFromList([nextYear, nextMonth, day]);
            }

            return result.millisecondsSinceEpoch;
          }, oneDayInMs);
          break;
        case RepeatCycle.week:
          await generateMission((lastStartAt) {
            int startAt = lastStartAt ?? quest.startAt - oneDayInMs;
            Jiffy? result;
            Jiffy startTime = Jiffy.parseFromMillisecondsSinceEpoch(startAt).startOf(Unit.day);
            final weekDays = quest.repeatData;

            for (int i in weekDays) {
              int daysToAdd = (i - (startTime.dayOfWeek - 1) + 7) % 7;
              if (daysToAdd == 0) daysToAdd = 7;

              final newDateTime = startTime.add(days: daysToAdd);

              if (result == null || result.isAfter(newDateTime)) result = newDateTime;
            }
            return result?.millisecondsSinceEpoch ?? (startAt + oneDayInMs);
          }, oneDayInMs);
          break;
        case RepeatCycle.dayPerDays:
          await generateMission((lastStartAt) {
            if (lastStartAt == null) {
              return Jiffy.parseFromMillisecondsSinceEpoch(quest.startAt).startOf(Unit.day).millisecondsSinceEpoch;
            }
            return Jiffy.parseFromMillisecondsSinceEpoch(lastStartAt)
                .add(days: quest.repeatData[0])
                .startOf(Unit.day)
                .millisecondsSinceEpoch;
          }, oneDayInMs);
          break;
        case RepeatCycle.days:
          await generateMission((lastStartAt) {
            if (lastStartAt == null) {
              return Jiffy.parseFromMillisecondsSinceEpoch(quest.startAt).startOf(Unit.day).millisecondsSinceEpoch;
            }
            return Jiffy.parseFromMillisecondsSinceEpoch(lastStartAt)
                .add(days: quest.repeatData[0])
                .startOf(Unit.day)
                .millisecondsSinceEpoch;
          }, oneDayInMs * quest.repeatData[0]);
      }
    }
  }

  Future<void> addQuest(Quest quest) async {
    await firebaseProvider?.saveQuestToFirestore(quest);
    questMap[quest.id] = quest;
    validateMission();
    notifyListeners();
  }

  Future<void> addMission(Mission mission) async {
    await firebaseProvider?.saveMissionToFirestore(mission);
    missionMap[mission.id] = mission;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await firebaseProvider?.saveTaskToFirestore(task);
    taskMap[task.id] = task;
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    await firebaseProvider?.saveTagToFirestore(tag);
    tagMap[tag.id] = tag;
  }

  Future<Tag> getTagByName(String tagName) async {
    final tag = tagMap.values.firstWhere((Tag t) {
      return t.name == tagName;
    }, orElse: () => Tag(id: randomId(), name: tagName));

    if (tagMap[tag.id] == null) {
      await addTag(tag);
    }

    return tag;
  }
}
