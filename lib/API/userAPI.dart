import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

final _auth = FirebaseAuth.instance;

class userAPI {
// SignIn

  Future<String?> signIn(String email, String password) async {
    final uid = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => uid);

    return uid.user?.uid;
  }
  // SignUp

  dynamic signUp(
      String email, String password, String name, String mobile) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
        'email': email,
        'uid': value.user!.uid,
        'name': name,
        'mobile': mobile
      });
    });
  }

  // Reset Password

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        await Fluttertoast.showToast(msg: "ଏହି ଇମେଲର ରେଜିଷ୍ଟ୍ରି ହୋଇ ନାହିଁ");
      }
    }
  }

// signout
  dynamic logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
}
