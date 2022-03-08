import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/login/usermodel.dart';
import 'package:flutter_application_1/nigam_lahari.dart';

import 'package:fluttertoast/fluttertoast.dart';

final _auth = FirebaseAuth.instance;
final _formkey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController();
final TextEditingController passswordController = TextEditingController();

// Create a text controller and use it to retrieve the current value of the TextField.

final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
final nameController = TextEditingController();
final mobileController = TextEditingController();

class userAPI {
  void signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {});
  }

  dynamic signUp(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore()})
        .catchError(
      (e) {
        Fluttertoast.showToast(msg: e!.message);
      },
    );
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our data
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    AppUser data = AppUser();

    // writing all the values
    data.email = user!.email;
    data.uid = user.uid;
    data.name = nameController.text;
    data.mobile = mobileController.text;

    await firebaseFirestore.collection("users").doc(user.uid).set(
          data.toMap(),
        );
    await Fluttertoast.showToast(msg: "Account created successfully :) ");
    return NigamLahari();
  }
}