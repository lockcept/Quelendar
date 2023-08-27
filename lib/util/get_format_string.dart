import 'package:jiffy/jiffy.dart';

String getDateformatString(int timestamp) {
  return Jiffy.parseFromMillisecondsSinceEpoch(timestamp).format(pattern: 'yyyy년 MM월 dd일');
}
