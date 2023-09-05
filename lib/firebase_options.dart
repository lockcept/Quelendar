// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAzYE21LdO4B53rr2SGiDGgJvKS3W9Sfp8',
    appId: '1:1018928109248:web:cf87826ff482c3a9dfff25',
    messagingSenderId: '1018928109248',
    projectId: 'quelendar-lockcept',
    authDomain: 'quelendar-lockcept.firebaseapp.com',
    storageBucket: 'quelendar-lockcept.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXRTVgzs_H1XYVcFFhTiyyRLnxmoYgRsY',
    appId: '1:1018928109248:android:dab68caa09231a08dfff25',
    messagingSenderId: '1018928109248',
    projectId: 'quelendar-lockcept',
    storageBucket: 'quelendar-lockcept.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIp_1Nd8LaVlylaTEsbaCHIDvlOWBuYas',
    appId: '1:1018928109248:ios:446ec2655f851d3fdfff25',
    messagingSenderId: '1018928109248',
    projectId: 'quelendar-lockcept',
    storageBucket: 'quelendar-lockcept.appspot.com',
    iosClientId: '1018928109248-kjsh2l5gm7e2hhp8i9ffj8oblmukh7qu.apps.googleusercontent.com',
    iosBundleId: 'com.example.questTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIp_1Nd8LaVlylaTEsbaCHIDvlOWBuYas',
    appId: '1:1018928109248:ios:606fbb0beb30a0e2dfff25',
    messagingSenderId: '1018928109248',
    projectId: 'quelendar-lockcept',
    storageBucket: 'quelendar-lockcept.appspot.com',
    iosClientId: '1018928109248-74mju09d9icmu4efh3hjfe3fncl05p0r.apps.googleusercontent.com',
    iosBundleId: 'com.example.questTracker.RunnerTests',
  );
}
