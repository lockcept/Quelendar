class Task {
  String id;
  String missionId;
  String name;
  int startAt;
  int? endAt;
  int value;

  Task({
    required this.id,
    required this.missionId,
    required this.name,
    required this.startAt,
    this.endAt,
    required this.value,
  });
}

enum AchievementType {
  minute('minute', '분'),
  count('count', '회');

  const AchievementType(this.id, this.label);
  final String id;
  final String label;

  factory AchievementType.getById(String id) {
    return AchievementType.values.firstWhere((value) => value.id == id, orElse: () => AchievementType.count);
  }

  factory AchievementType.getByLabel(String label) {
    return AchievementType.values.firstWhere((value) => value.label == label, orElse: () => AchievementType.count);
  }
}

class Mission {
  String id;
  String questId;
  int startAt;
  int endAt;
  int goal;
  String? comment;

  Mission({
    required this.id,
    required this.questId,
    required this.startAt,
    required this.endAt,
    required this.goal,
    this.comment,
  });
}

class Tag {
  String id;
  String name;

  Tag({required this.id, required this.name});
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

  factory RepeatCycle.getByType(String type) {
    return RepeatCycle.values.firstWhere((value) => value.type == type, orElse: () => RepeatCycle.none);
  }

  factory RepeatCycle.getByLabel(String label) {
    return RepeatCycle.values.firstWhere((value) => value.label == label, orElse: () => RepeatCycle.none);
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
  bool isDeleted;

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
    required this.isDeleted,
  });
}
