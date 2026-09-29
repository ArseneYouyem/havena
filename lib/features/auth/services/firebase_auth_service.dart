import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthService {
  FirebaseAuthService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  Future<String> createUserWithSecondaryApp({
    required String email,
    required String password,
  }) async {
    FirebaseApp? secondaryApp;
    try {
      try {
        secondaryApp = Firebase.app('secondaryAuth');
      } catch (_) {
        secondaryApp = await Firebase.initializeApp(
          name: 'secondaryAuth',
          options: Firebase.app().options,
        );
      }

      final auth = FirebaseAuth.instanceFor(app: secondaryApp);
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } finally {
      if (secondaryApp != null) {
        await secondaryApp.delete();
      }
    }
  }
}
