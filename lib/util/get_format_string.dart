import 'package:intl/intl.dart';

String getDateformatString(int timestamp) {
  return DateFormat('yyyy년 MM월 dd일')
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal());
}
