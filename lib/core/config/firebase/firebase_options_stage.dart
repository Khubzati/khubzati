import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyD19admZjTGNJ_zxq7-yjGnPLrlsPkE9fM',
    appId: '1:501090037216:android:64c6379be89ce9edfe4f85',
    messagingSenderId: '501090037216',
    projectId: 'khubzati-stage-269cf',
    storageBucket: 'khubzati-stage-269cf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCj9gnh8lTGGqoKSSqa-qjbVLJnxW2tc4',
    appId: '1:501090037216:ios:b7b639abf9f8a600fe4f85',
    messagingSenderId: '501090037216',
    projectId: 'khubzati-stage-269cf',
    storageBucket: 'khubzati-stage-269cf.firebasestorage.app',
    iosBundleId: 'com.khubzati.app.stage',
  );
}
