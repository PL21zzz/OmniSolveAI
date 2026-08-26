import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

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
        return ios;
      case TargetPlatform.windows:
        return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkrr2ZxwzQ0WZj_v4dfA8gFGkQ-ZJFcjg',
    appId: '1:248928705874:web:74d916a178fb49e1066e8b',
    messagingSenderId: '248928705874',
    projectId: 'omnisolve-ai-1630b',
    authDomain: 'omnisolve-ai-1630b.firebaseapp.com',
    storageBucket: 'omnisolve-ai-1630b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkrr2ZxwzQ0WZj_v4dfA8gFGkQ-ZJFcjg',
    appId: '1:248928705874:ios:74d916a178fb49e1066e8b',
    messagingSenderId: '248928705874',
    projectId: 'omnisolve-ai-1630b',
    storageBucket: 'omnisolve-ai-1630b.firebasestorage.app',
    iosBundleId: 'com.omnisolve.omniSolveAi',
  );
}
