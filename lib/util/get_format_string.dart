import 'package:jiffy/jiffy.dart';

String getDateformatString(int timestamp, {bool detail = false}) {
  if (detail) return Jiffy.parseFromMillisecondsSinceEpoch(timestamp).format(pattern: 'yyyy년 MM월 dd일 HH시 mm분');
  return Jiffy.parseFromMillisecondsSinceEpoch(timestamp).format(pattern: 'yyyy년 MM월 dd일');
}

String getDateRangeformatString(int startAt, int endAt) {
  final startDate = Jiffy.parseFromMillisecondsSinceEpoch(startAt).format(pattern: 'yy/MM/dd');
  final endDate = Jiffy.parseFromMillisecondsSinceEpoch(endAt - 1).format(pattern: 'yy/MM/dd');
  if (startDate == endDate) return startDate;
  return '$startDate~$endDate';
}

List<int> getListFromTimestamp(int timestamp) {
  final jiffy = Jiffy.parseFromMillisecondsSinceEpoch(timestamp);
  return [jiffy.year, jiffy.month, jiffy.date, jiffy.hour, jiffy.minute, jiffy.second];
}
