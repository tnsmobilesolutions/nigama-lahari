import 'package:flutter/material.dart';
import 'package:flutter_application_1/API/userAPI.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  var email = "";

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notice = Text(
      'ପାସୱର୍ଡ ପୁନଃସେଟ ପାଇଁ ଆପଣଙ୍କ ଇମେଲକୁ ଲିଙ୍କ ଯିବ',
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('ପାସୱର୍ଡ ପୁନଃସେଟ କରନ୍ତୁ'),
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
                style: ElevatedButton.styleFrom(primary: Constant.orange),
                child: Text('ଅନୁରୋଧ କରନ୍ତୁ'),
                onPressed: () async {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      email = emailController.text;
                    });
                    await userAPI().resetPassword(email);
                    await Fluttertoast.showToast(
                        msg: 'ଲିଙ୍କ ଆପଣଙ୍କ ଇମେଲକୁ ଯାଇଛି');
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
