// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyCOjHhS9qsI6pEiHYd0qywZuBiJwy3DDg4',
    appId: '1:211317490313:web:fdb22f35a62643b9a1fc58',
    messagingSenderId: '211317490313',
    projectId: 'meatwell-aa322',
    authDomain: 'meatwell-aa322.firebaseapp.com',
    storageBucket: 'meatwell-aa322.firebasestorage.app',
    measurementId: 'G-8C7YLR7C26',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBK8gDoMFUsDkA8OaSsKd8qAiB5u2_wc0E',
    appId: '1:211317490313:android:3f5779aa5de51208a1fc58',
    messagingSenderId: '211317490313',
    projectId: 'meatwell-aa322',
    storageBucket: 'meatwell-aa322.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8hU_KLKPdyRLSZ7zzG7VTEqNHSTaq2GM',
    appId: '1:211317490313:ios:a8a31c1855c4d46ca1fc58',
    messagingSenderId: '211317490313',
    projectId: 'meatwell-aa322',
    storageBucket: 'meatwell-aa322.firebasestorage.app',
    iosBundleId: 'com.example.fitness2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8hU_KLKPdyRLSZ7zzG7VTEqNHSTaq2GM',
    appId: '1:211317490313:ios:a8a31c1855c4d46ca1fc58',
    messagingSenderId: '211317490313',
    projectId: 'meatwell-aa322',
    storageBucket: 'meatwell-aa322.firebasestorage.app',
    iosBundleId: 'com.example.fitness2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOjHhS9qsI6pEiHYd0qywZuBiJwy3DDg4',
    appId: '1:211317490313:web:ed0fb6b799c85b73a1fc58',
    messagingSenderId: '211317490313',
    projectId: 'meatwell-aa322',
    authDomain: 'meatwell-aa322.firebaseapp.com',
    storageBucket: 'meatwell-aa322.firebasestorage.app',
    measurementId: 'G-4MT7T434WZ',
  );
}
