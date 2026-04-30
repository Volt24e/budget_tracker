import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAd5qflW4n-N585bg0yYd33hMHpCG7yhPE",
    appId: "1:346484306439:web:fc77be5ae7d5459c0970a2",
    messagingSenderId: "346484306439",
    projectId: "budget-tracker-app-d6cf6",
    authDomain: "budget-tracker-app-d6cf6.firebaseapp.com",
    storageBucket: "budget-tracker-app-d6cf6.firebasestorage.app",
  );
}
