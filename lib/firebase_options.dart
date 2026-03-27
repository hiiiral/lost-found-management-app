// Generated template for Firebase options.
// Replace the placeholder strings with values from your Firebase project
// or run the FlutterFire CLI (`flutterfire configure`) to generate this file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnzal-6ZNm9gNduhbg5P3zrL0WYFEDf7c',
    appId: '1:450593921560:web:bef47ab11691c02c08416d',
    messagingSenderId: '450593921560',
    projectId: 'lost-found-cms-43ca3',
    authDomain: 'lost-found-cms-43ca3.firebaseapp.com',
    storageBucket: 'lost-found-cms-43ca3.firebasestorage.app',
    measurementId: 'G-VT7C93S51K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB26gHfdlZYweSvOnbWFm6FTHTbz0N_JBk',
    appId: '1:450593921560:android:c08b53adeda7e13a08416d',
    messagingSenderId: '450593921560',
    projectId: 'lost-found-cms-43ca3',
    storageBucket: 'lost-found-cms-43ca3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXEQ5niUP-RepzzzdCg1glCeYU6x4Xqvg',
    appId: '1:450593921560:ios:3e6322e51719d0af08416d',
    messagingSenderId: '450593921560',
    projectId: 'lost-found-cms-43ca3',
    storageBucket: 'lost-found-cms-43ca3.firebasestorage.app',
    iosBundleId: 'com.example.lostFoundCms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXEQ5niUP-RepzzzdCg1glCeYU6x4Xqvg',
    appId: '1:450593921560:ios:3e6322e51719d0af08416d',
    messagingSenderId: '450593921560',
    projectId: 'lost-found-cms-43ca3',
    storageBucket: 'lost-found-cms-43ca3.firebasestorage.app',
    iosBundleId: 'com.example.lostFoundCms',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBnzal-6ZNm9gNduhbg5P3zrL0WYFEDf7c',
    appId: '1:450593921560:web:f16f31167d7b052208416d',
    messagingSenderId: '450593921560',
    projectId: 'lost-found-cms-43ca3',
    authDomain: 'lost-found-cms-43ca3.firebaseapp.com',
    storageBucket: 'lost-found-cms-43ca3.firebasestorage.app',
    measurementId: 'G-HVY6WLWDYQ',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}