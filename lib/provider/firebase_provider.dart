import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
