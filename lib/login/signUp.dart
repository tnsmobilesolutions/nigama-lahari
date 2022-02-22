import 'dart:math';

import 'package:flutter/material.dart';

import '../homePage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // bool loading = false;

  // String? _email;

  // String? _password;

  // final _auth = FirebaseAuth.instance;

  // final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    const photo = CircleAvatar(
      radius: 50,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: Text('Add Your Photo'),
      ),
    );
    final Name = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        value = nameController.text;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Full Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final mobileNum = TextFormField(
      autofocus: false,
      controller: mobileController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        value = mobileController.text;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Phone Number',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final email = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        value = emailController.text;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Email Id',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final password = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        value = passwordController.text;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final confirmPassword = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: confirmPasswordController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        value = confirmPasswordController.text;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final save = Material(
      color: Colors.redAccent,
      elevation: 5,
      borderRadius: BorderRadius.circular(18),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        },
        child: const Text(
          'Save',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        padding: const EdgeInsets.all(8),
        minWidth: MediaQuery.of(context).size.width,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 50,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      photo,
                      const SizedBox(height: 20),
                      Name,
                      const SizedBox(height: 20),
                      mobileNum,
                      const SizedBox(height: 20),
                      email,
                      const SizedBox(height: 20),
                      password,
                      const SizedBox(height: 20),
                      confirmPassword,
                      const SizedBox(height: 20),
                      save
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
