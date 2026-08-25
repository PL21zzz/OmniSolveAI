import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkrr2ZxwzQ0WZj_v4dfA8gFGkQ-ZJFcjg',
    appId: '1:248928705874:android:74d916a178fb49e1066e8b',
    messagingSenderId: '248928705874',
    projectId: 'omnisolve-ai-1630b',
    storageBucket: 'omnisolve-ai-1630b.firebasestorage.app',
  );
}
