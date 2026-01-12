import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyABC123...',
    appId: '1:123456789012:web:abc123def456',
    messagingSenderId: '123456789012',
    projectId: 'spoton-game-12345',
    authDomain: 'spoton-game-12345.firebaseapp.com',
    databaseURL: 'https://spoton-game-12345-default-rtdb.firebaseio.com',
    storageBucket: 'spoton-game-12345.appspot.com',
    measurementId: 'G-ABC123XYZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEF456...',
    appId: '1:123456789012:android:abc123def456',
    messagingSenderId: '123456789012',
    projectId: 'spoton-game-12345',
    storageBucket: 'spoton-game-12345.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyCIPT9OU9nKLPrBL4VH_vITHN-sBNwMe8E",
    appId: "1:1087665115176:web:5652982f2531ce27a8a51d",
    messagingSenderId: '123456789012',
    projectId: 'spoton-game-12345',
    storageBucket: 'spoton-game-12345.appspot.com',
    iosBundleId: 'com.example.spotonGame',
    iosClientId: '123456789012-abc123def456.apps.googleusercontent.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyJKL012...',
    appId: '1:123456789012:macos:abc123def456',
    messagingSenderId: '123456789012',
    projectId: 'spoton-game-12345',
    storageBucket: 'spoton-game-12345.appspot.com',
    iosBundleId: 'com.example.spotonGame',
    iosClientId: '123456789012-abc123def456.apps.googleusercontent.com',
  );
}