import 'package:quest_tracker/quest.dart';

var tag = Tag(id: 'smANMTFuNx', name: '록셉');

var quest1 = Quest(
  id: 'PCv6mDVl30',
  name: 'game',
  tagIdList: ['smANMTFuNx'],
  startAt: 1690452492,
  duration: 7,
  repeatCycle: RepeatCycle.days,
  repeatData: [7],
  achievementType: AchievementType.count,
  goal: 10,
);

var quest2 = Quest(
  id: 'yPJHhdxvBG',
  name: 'coding',
  tagIdList: ['smANMTFuNx'],
  startAt: 1690452492,
  duration: 1,
  repeatCycle: RepeatCycle.week,
  repeatData: [0, 1, 2, 3, 4],
  achievementType: AchievementType.minute,
  goal: 60 * 5,
);

var quest3 = Quest(
  id: 'CiBnEQm9g0',
  name: 'money',
  tagIdList: [],
  startAt: 1690452492,
  duration: 1,
  repeatCycle: RepeatCycle.month,
  repeatData: [5],
  achievementType: AchievementType.count,
  goal: 1,
);
