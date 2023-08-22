import 'package:flutter/material.dart';
import 'package:quelendar/quest.dart';

class MissionItem extends StatelessWidget {
  final Mission mission;
  const MissionItem({required this.mission, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('미션 아이템 ${mission.id}'),
    );
  }
}
