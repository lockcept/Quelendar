import 'package:flutter/material.dart';
import 'package:quest_tracker/body/home_body.dart';

import 'body/quest_body.dart';
import 'body/setting_body.dart';

class QuestTracker extends StatefulWidget {
  const QuestTracker({super.key});

  @override
  QuestTrackerState createState() => QuestTrackerState();
}

class QuestTrackerState extends State<QuestTracker> {
  int currentPageIndex = 1;

  final bodyList = <Widget>[
    const HomeBody(),
    const QuestBody(),
    const SettingBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '퀘스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
      body: bodyList[currentPageIndex],
    );
  }
}
