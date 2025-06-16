import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB_Qv7jU86895QSKwFd7nqOScCie9iUwFE',
    appId: '1:38738038916:web:dummywebappid', // Dummy vì bạn chưa tạo web app
    messagingSenderId: '38738038916',
    projectId: 'note-manager-cd269',
    storageBucket: 'note-manager-cd269.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_Qv7jU86895QSKwFd7nqOScCie9iUwFE',
    appId: '1:38738038916:android:3443feb58a742bcff5b2d1',
    messagingSenderId: '38738038916',
    projectId: 'note-manager-cd269',
    storageBucket: 'note-manager-cd269.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_Qv7jU86895QSKwFd7nqOScCie9iUwFE',
    appId: '1:38738038916:ios:dummyiosappid', // Dummy vì bạn chưa tạo iOS app
    messagingSenderId: '38738038916',
    projectId: 'note-manager-cd269',
    storageBucket: 'note-manager-cd269.firebasestorage.app',
    iosBundleId: 'com.example.flutterNoteManager', // placeholder nếu sau này làm iOS
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_Qv7jU86895QSKwFd7nqOScCie9iUwFE',
    appId: '1:38738038916:macos:dummymacosappid', // Dummy vì bạn chưa tạo macOS app
    messagingSenderId: '38738038916',
    projectId: 'note-manager-cd269',
    storageBucket: 'note-manager-cd269.firebasestorage.app',
  );
}
