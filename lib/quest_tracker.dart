import 'package:flutter/material.dart';

class QuestTracker extends StatefulWidget {
  const QuestTracker({super.key});

  @override
  QuestTrackerState createState() => QuestTrackerState();
}

class QuestTrackerState extends State<QuestTracker> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.list),
            label: '퀘스트',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text('퀘스트 페이지'),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text('통계 페이지'),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text('설정 페이지'),
        ),
      ][currentPageIndex],
    );
  }
}
