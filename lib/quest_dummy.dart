import 'package:quest_tracker/quest.dart';

var quest1 = Quest(
  id: 'lockcept',
  name: 'game',
  tagList: [],
  startAt: 1690452492,
  duration: 7,
  repeatCycle: RepeatCycle.days,
  repeatData: [7],
  achievementType: AchievementType.count,
  goal: 10,
  missionList: [],
);

var quest2 = Quest(
  id: 'lockcept',
  name: 'coding',
  tagList: [],
  startAt: 1690452492,
  duration: 1,
  repeatCycle: RepeatCycle.week,
  repeatData: [0, 1, 2, 3, 4],
  achievementType: AchievementType.minute,
  goal: 60 * 5,
  missionList: [],
);

var quest3 = Quest(
  id: 'lockcept',
  name: 'money',
  tagList: [],
  startAt: 1690452492,
  duration: 1,
  repeatCycle: RepeatCycle.month,
  repeatData: [5],
  achievementType: AchievementType.count,
  goal: 1,
  missionList: [],
);
