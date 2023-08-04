import 'package:flutter/material.dart';

class QuestTracker extends StatefulWidget {
  const QuestTracker({super.key});

  @override
  QuestTrackerState createState() => QuestTrackerState();
}

class QuestTrackerState extends State<QuestTracker> {
  int currentPageIndex = 0;

  late List<Widget> bodyList;

  QuestTrackerState() {
    bodyList = <Widget>[
      Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User 1'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User 2'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User 3'),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Text('퀘스트'),
      ),
      Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Text('설정'),
      ),
    ];
  }

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
            label: '미션',
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
