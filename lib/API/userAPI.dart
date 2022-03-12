import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/data_store.dart';

import 'package:flutter_application_1/models/usermodel.dart';

import 'package:fluttertoast/fluttertoast.dart';

final _auth = FirebaseAuth.instance;
// final _emailController = TextEditingController();
// final _nameController = TextEditingController();
// final _mobileController = TextEditingController();

class userAPI {
// SignIn

  dynamic signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {});
    // TODO: If success then call This
    await DataStore().loadAllData();

    // TODO: Remove this from here to the UI layer
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

    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User? user = _auth.currentUser;

    // AppUser UserModel = AppUser();
    // UserModel.email = email;
    // UserModel.uid = user.uid;
    // UserModel.name = name;
    // UserModel.mobile = mobile;

    // writing all the values
    // data.email = user!.email;
    // data.uid = user.uid;
    // data.name = _nameController.text;
    // data.mobile = _mobileController.text;

    // await firebaseFirestore.collection("users").doc(user.uid).set(
    //       UserModel.toMap(),
    // );
  }

  // postDetailsToFirestore() async {
  // calling our firestore
  // calling our data
  // sedning these values

  // Reset Password

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      await Fluttertoast.showToast(
          msg: "Password Reset Email has been sent  :) ");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        await Fluttertoast.showToast(msg: "No user found for that email.:) ");
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
// keep user logged

  // dynamic currentUser() async {
  //   await FirebaseAuth.instance.currentUser;
  // }
}
