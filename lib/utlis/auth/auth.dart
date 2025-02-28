import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // create instance for firebaseAuth and googleSignIn
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // sign in with google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      // get authentication details form google user
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // create new credentail using token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // use the credentail to sign with firebase
      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    }
    // if sign in was canceled
    return null;
  }

  // sign out from both google and firebase
  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
