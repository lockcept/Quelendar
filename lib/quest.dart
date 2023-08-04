import 'package:nanoid/nanoid.dart';

class Task {
  int id;
  int missionId;
  int startAt;
  int? endAt;
  int value;
  String? comment;

  Task({
    required this.id,
    required this.missionId,
    required this.startAt,
    this.endAt,
    required this.value,
    this.comment,
  });
}

enum AchievementType {
  minute('minute'),
  count('count');

  const AchievementType(this.id);
  final String id;
}

class Mission {
  int id;
  int questId;
  int startAt;
  int endAt;
  AchievementType achievementType;
  int goal;

  Mission({
    required this.id,
    required this.questId,
    required this.startAt,
    required this.endAt,
    required this.achievementType,
    required this.goal,
  });
}

class Tag {
  String id;
  String name;

  Tag({required this.id, required this.name});

  Tag.create({required this.name}) : id = nanoid();
}

enum RepeatCycle {
  month('month'),
  week('week'),
  days('days'),
  none('none');

  const RepeatCycle(this.type);
  final String type;
}

class Quest {
  String id;
  String name;
  List<String> tagIdList;
  int startAt;
  int? endAt;
  int duration;
  RepeatCycle repeatCycle;
  List<int> repeatData;
  AchievementType achievementType;
  int goal;

  Quest({
    required this.id,
    required this.name,
    required this.tagIdList,
    required this.startAt,
    this.endAt,
    required this.duration,
    required this.repeatCycle,
    required this.repeatData,
    required this.achievementType,
    required this.goal,
  });
}