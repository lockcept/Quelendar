import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quelendar/quest.dart';

class FirebaseProvider with ChangeNotifier {
  User? user;

  FirebaseProvider() {
    FirebaseAuth.instance.idTokenChanges().listen((User? googleUser) async {
      if (googleUser == null) {
        if (user == null) return;

        user = null;
        debugPrint('로그아웃 성공');

        notifyListeners();
      } else {
        if (user?.uid == googleUser.uid) return;

        user = googleUser;
        debugPrint('로그인 성공 ${user?.displayName ?? ""}');
        notifyListeners();
      }
    });
  }

  Future<void> initData(Map<String, Quest> questMap, Map<String, Mission> missionMap, Map<String, Task> taskMap,
      Map<String, Tag> tagMap) async {
    if (user == null) return;

    final uid = user!.uid;

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('quest').where('userId', isEqualTo: uid).get();

      for (var doc in querySnapshot.docs) {
        final questData = doc.data() as Map<String, dynamic>;

        final quest = Quest(
          id: questData['id'],
          name: questData['name'],
          tagIdList: List<String>.from(questData['tagIdList']),
          startAt: questData['startAt'],
          endAt: questData['endAt'],
          repeatCycle: RepeatCycle.getByType(questData['repeatCycle']),
          repeatData: List<int>.from(questData['repeatData']),
          achievementType: AchievementType.getById(questData['achievementType']),
          goal: questData['goal'],
        );

        questMap[quest.id] = quest;
      }
    } catch (e) {
      debugPrint('Error getting quest: $e');
    }

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('mission').where('userId', isEqualTo: uid).get();

      for (var doc in querySnapshot.docs) {
        final missionData = doc.data() as Map<String, dynamic>;

        final mission = Mission(
          id: missionData['id'],
          questId: missionData['questId'],
          startAt: missionData['startAt'],
          endAt: missionData['endAt'],
          goal: missionData['goal'],
          comment: missionData['comment'],
        );

        missionMap[mission.id] = mission;
      }
    } catch (e) {
      debugPrint('Error getting mission: $e');
    }

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('task').where('userId', isEqualTo: uid).get();

      for (var doc in querySnapshot.docs) {
        final taskData = doc.data() as Map<String, dynamic>;

        final task = Task(
          id: taskData['id'],
          missionId: taskData['missionId'],
          name: taskData['name'],
          startAt: taskData['startAt'],
          endAt: taskData['endAt'],
          value: taskData['value'],
        );

        taskMap[task.id] = task;
      }
    } catch (e) {
      debugPrint('Error getting task: $e');
    }

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tag').where('userId', isEqualTo: uid).get();

      for (var doc in querySnapshot.docs) {
        final tagData = doc.data() as Map<String, dynamic>;

        final tag = Tag(
          id: tagData['id'],
          name: tagData['name'],
        );

        tagMap[tag.id] = tag;
      }
    } catch (e) {
      debugPrint('Error getting tag: $e');
    }
  }

  Future<void> saveQuestToFirestore(Quest quest) async {
    if (user == null) return;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Map<String, dynamic> questData = {
        'userId': user!.uid,
        'id': quest.id,
        'name': quest.name,
        'tagIdList': quest.tagIdList,
        'startAt': quest.startAt,
        'endAt': quest.endAt,
        'repeatCycle': quest.repeatCycle.type, // RepeatCycle의 라벨을 저장
        'repeatData': quest.repeatData,
        'achievementType': quest.achievementType.id, // AchievementType의 라벨을 저장
        'goal': quest.goal,
      };

      // Firestore에 데이터 추가
      await firestore.collection('quest').doc(quest.id).set(questData);
    } catch (e) {
      debugPrint('Firestore 퀘스트 저장 오류: $e');
    }
  }

  Future<void> saveMissionToFirestore(Mission mission) async {
    if (user == null) return;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> missionData = {
        'userId': user!.uid,
        'id': mission.id,
        'questId': mission.questId,
        'startAt': mission.startAt,
        'endAt': mission.endAt,
        'goal': mission.goal,
        'comment': mission.comment,
      };
      await firestore.collection('mission').doc(mission.id).set(missionData);
    } catch (e) {
      debugPrint('Firestore 미션 저장 오류: $e');
    }
  }

  Future<void> saveTaskToFirestore(Task task) async {
    if (user == null) return;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> taskData = {
        'userId': user!.uid,
        'id': task.id,
        'missionId': task.missionId,
        'name': task.name,
        'startAt': task.startAt,
        'endAt': task.endAt,
        'value': task.value,
      };
      await firestore.collection('task').doc(task.id).set(taskData);
    } catch (e) {
      debugPrint('Firestore 태스크 저장 오류: $e');
    }
  }

  Future<void> saveTagToFirestore(Tag tag) async {
    if (user == null) return;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> tagData = {
        'userId': user!.uid,
        'id': tag.id,
        'name': tag.name,
      };
      await firestore.collection('tag').doc(tag.id).set(tagData);
    } catch (e) {
      debugPrint('Firestore 태그 저장 오류: $e');
    }
  }

  Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      // 웹
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      debugPrint("앱");
      // 앱
    }
  }
}
