import 'package:nanoid/nanoid.dart';

class Task {
  String id;
  String missionId;
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
  minute('minute', '분'),
  count('count', '회');

  const AchievementType(this.id, this.label);
  final String id;
  final String label;

  factory AchievementType.getByLabel(String label) {
    return AchievementType.values.firstWhere((value) => value.label == label,
        orElse: () => AchievementType.count);
  }
}

class Mission {
  String id;
  String questId;
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
  month('month', "매달"),
  week('week', "매주"),
  dayPerDays('dayPerDays', "며칠마다"),
  days('days', "며칠에 걸쳐"),
  none('none', "반복 없음");

  const RepeatCycle(this.type, this.label);
  final String type;
  final String label;

  factory RepeatCycle.getByLabel(String label) {
    return RepeatCycle.values.firstWhere((value) => value.label == label,
        orElse: () => RepeatCycle.none);
  }
}

class Quest {
  String id;
  String name;
  List<String> tagIdList;
  int startAt;
  int? endAt;
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
    required this.repeatCycle,
    required this.repeatData,
    required this.achievementType,
    required this.goal,
  });
}
