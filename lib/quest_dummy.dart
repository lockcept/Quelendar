import 'package:quest_tracker/quest.dart';

final tag1 = Tag(id: 'smANMTFuNx', name: '자기_계발');
final tag2 = Tag(id: 'K1MOt3PaBl', name: '개발');

final quest1 = Quest(
  id: 'PCv6mDVl30',
  name: '숙제하기',
  tagIdList: ['smANMTFuNx'],
  startAt: 1690452492000,
  repeatCycle: RepeatCycle.days,
  repeatData: [7],
  achievementType: AchievementType.count,
  goal: 10,
);

final quest2 = Quest(
  id: 'yPJHhdxvBG',
  name: '앱 개발하기',
  tagIdList: ['smANMTFuNx', 'K1MOt3PaBl'],
  startAt: 1690452492000,
  repeatCycle: RepeatCycle.week,
  repeatData: [0, 1, 2, 3, 4],
  achievementType: AchievementType.minute,
  goal: 60 * 5,
);

final quest3 = Quest(
  id: 'CiBnEQm9g0',
  name: '월세 내기',
  tagIdList: [],
  startAt: 1690452492000,
  repeatCycle: RepeatCycle.month,
  repeatData: [5],
  achievementType: AchievementType.count,
  goal: 1,
);

final quest4 = Quest(
  id: 'qhWJ8yBKSF',
  name: '팔굽혀펴기',
  tagIdList: [],
  startAt: 1690452492000,
  repeatCycle: RepeatCycle.week,
  repeatData: [0, 2, 4],
  achievementType: AchievementType.count,
  goal: 20,
);
