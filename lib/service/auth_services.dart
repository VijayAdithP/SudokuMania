import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  signInwithGoogle() async {
    // initiate sign-in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // if cancelled
    if (gUser == null) return;

    //get auth details
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
