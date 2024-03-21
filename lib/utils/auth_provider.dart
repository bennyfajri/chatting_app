import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userProvider = NotifierProvider<UserProvider, FirebaseAuth>(UserProvider.new);

final firestoreProvider = StateProvider((ref) => FirebaseFirestore.instance);

class UserProvider extends Notifier<FirebaseAuth> {

  @override
  FirebaseAuth build() {
    return FirebaseAuth.instance;
  }

  void signOut() {
    state.signOut();
    GoogleSignIn().signOut();
    state.authStateChanges();
    state = FirebaseAuth.instance;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await state.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password)  async {
    return await state.signInWithEmailAndPassword(email: email, password: password);
  }

}