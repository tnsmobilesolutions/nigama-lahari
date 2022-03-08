import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/API/userAPI.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  var email = "";

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notice = Text(
      'Reset Link will be\nsent to your email id !',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
    final emailField = TextFormField(
      controller: emailController,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "ନିଜ ଇମେଲ ଲେଖନ୍ତୁ";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("ଦୟା କରି ନିଜ ସଠିକ ଇମେଲ ଲେଖନ୍ତୁ");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.all(15),
          hintText: 'ନିଜ ଇମେଲ ଲେଖନ୍ତୁ',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reset Password'),
      ),
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              notice,
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: emailField,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Send Request'),
                onPressed: () async {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      email = emailController.text;
                    });
                    await userAPI().resetPassword(email);
                    await Fluttertoast.showToast(
                        msg: 'Password Sent successfull');
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
