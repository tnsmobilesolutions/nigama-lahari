// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/login/usermodel.dart';
// import 'package:flutter_application_1/nigamLahari/nigam_lahari.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// final _auth = FirebaseAuth.instance;
// final _formkey = GlobalKey<FormState>();
// final TextEditingController emailController = TextEditingController();
// final TextEditingController passswordController = TextEditingController();

// // Create a text controller and use it to retrieve the current value of the TextField.

// final passwordController = TextEditingController();
// final confirmPasswordController = TextEditingController();
// final nameController = TextEditingController();
// final mobileController = TextEditingController();

// class authAPI {
//   void signIn(String email, String password) async {
//     if (_formkey.currentState!.validate()) {
//       await _auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .then((uid) => {
//                 Fluttertoast.showToast(msg: "Login Successful"),
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => NigamLahari())),
//               });
//     }

//     void signUp(String email, String password) async {
//       if (_formkey.currentState!.validate()) {
//         await _auth
//             .createUserWithEmailAndPassword(email: email, password: password)
//             .then((value) => {postDetailsToFirestore()})
//             .catchError((e) {
//           Fluttertoast.showToast(msg: e!.message);
//         });
//       }
//     }

//     postDetailsToFirestore() async {
//       // calling our firestore
//       // calling our data
//       // sedning these values

//       FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//       User? user = _auth.currentUser;

//       AppUser data = AppUser();

//       // writing all the values
//       data.email = user!.email;
//       data.uid = user.uid;
//       data.name = nameController.text;
//       data.mobile = mobileController.text;

//       await firebaseFirestore.collection("users").doc(user.uid).set(
//             data.toMap(),
//           );
//       Fluttertoast.showToast(msg: "Account created successfully :) ");

//       Navigator.pushAndRemoveUntil(
//           (context),
//           MaterialPageRoute(builder: (context) => NigamLahari()),
//           (route) => false);
//     }
//   }
// }
