import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDa4NMYz4bd70pqUgnbjS6goydifu7kSL8',
    appId: '1:19603541521:android:571c9066d58de2d526abb0',
    messagingSenderId: '19603541521',
    projectId: 'khubzati-dev-131af',
    storageBucket: 'khubzati-dev-131af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqfe10ACqpCAqn07t234NAnByVBx8K-TA',
    appId: '1:19603541521:ios:3f45003d5d37777126abb0',
    messagingSenderId: '19603541521',
    projectId: 'khubzati-dev-131af',
    storageBucket: 'khubzati-dev-131af.firebasestorage.app',
    iosBundleId: 'com.khubzati.app.dev',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDa4NMYz4bd70pqUgnbjS6goydifu7kSL8',
    appId: '1:19603541521:web:571c9066d58de2d526abb0',
    messagingSenderId: '19603541521',
    projectId: 'khubzati-dev-131af',
    storageBucket: 'khubzati-dev-131af.firebasestorage.app',
    authDomain: 'khubzati-dev-131af.firebaseapp.com',
  );
}
