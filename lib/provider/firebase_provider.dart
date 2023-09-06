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

  Future<void> initData(Map<String, Quest> questMap) async {
    if (user == null) return;

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('quest').where('userId', isEqualTo: user!.uid).get();

      for (var doc in querySnapshot.docs) {
        final quest = doc.data();

        debugPrint(quest.toString());

        // questMap[quest.id] = Quest(quest);
      }
    } catch (e) {
      debugPrint('Error getting quest: $e');
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
