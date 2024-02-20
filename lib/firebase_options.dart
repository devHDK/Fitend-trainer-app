// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:fitend_trainer_app/flavors.dart';
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

  static final FirebaseOptions android = F.appFlavor == Flavor.production
      ? const FirebaseOptions(
          apiKey: 'AIzaSyCveB2_0-d_LPjjC8Vt3VUd8bN576kqPIU',
          appId: '1:533675600650:android:5e011f83f40be63a4328f3',
          messagingSenderId: '533675600650',
          projectId: 'fitend-prod',
          storageBucket: 'fitend-prod.appspot.com',
        )
      : const FirebaseOptions(
          apiKey: 'AIzaSyAuBICRjn3xDdkfB4OR2sMCeb1xCRdLdQU',
          appId: '1:924335070648:android:673ad3c7b4cce903d0c34d',
          messagingSenderId: '924335070648',
          projectId: 'fitend-dev',
          storageBucket: 'fitend-dev.appspot.com',
        );

  static final FirebaseOptions ios = F.appFlavor == Flavor.production
      ? const FirebaseOptions(
          apiKey: 'AIzaSyBkpTEfjXlc7ofiZAowFh1ipE-xjQ1v-VE',
          appId: '1:533675600650:ios:56d6038d8165e6b84328f3',
          messagingSenderId: '533675600650',
          projectId: 'fitend-prod',
          storageBucket: 'fitend-prod.appspot.com',
          iosClientId:
              '533675600650-klj8dv6kf97uc41sfqmfpeke6tkdiv5b.apps.googleusercontent.com',
          iosBundleId: 'com.raid.fitend.trainer',
        )
      : const FirebaseOptions(
          apiKey: 'AIzaSyDVAIzD3KEbglHNVxrw2wQCNCUkG2_59CQ',
          appId: '1:924335070648:ios:238e3abad62e8c2dd0c34d',
          messagingSenderId: '924335070648',
          projectId: 'fitend-dev',
          storageBucket: 'fitend-dev.appspot.com',
          iosClientId:
              '924335070648-9ul1f73qal52dq8tloa4ho78fsld9eur.apps.googleusercontent.com',
          iosBundleId: 'com.raid.fitend.trainer.dev',
        );
}