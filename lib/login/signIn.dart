import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/login/resetpasswordpage.dart';

import 'package:flutter_application_1/login/signUp.dart';
import 'package:flutter_application_1/API/userAPI.dart';

import '../models/usermodel.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? currentUserName;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passswordController = TextEditingController();
  bool signUp = false;

  final _formkey = GlobalKey<FormState>();
  AppUser? _loggedInUser;
  bool _obscureText = true;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Constant.orange,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.orange),
        ),
        prefixIcon: const Icon(Icons.email, color: Constant.orange),
        contentPadding: const EdgeInsets.all(15),
        hintText: 'ଇମେଲ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      obscureText: _obscureText,
      autofocus: false,
      controller: passswordController,

      //keyboardType: TextInputType.phone,
      validator: (value) {
        //RegExp regex = RegExp(r'^.{6}$');
        if (value!.isEmpty) {
          return "ନିଜ ପାସୱାଡ଼ ଲେଖନ୍ତୁ";
        }
        // if (!regex.hasMatch(value)) {
        //   return "ଦୟା କରି ନିଜ ସଠିକ ପାସୱାଡ଼  ଲେଖନ୍ତୁ";
        // }

        return null;
      },
      onSaved: (value) {
        passswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Constant.orange,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.orange),
        ),
        prefixIcon: const Icon(Icons.vpn_key, color: Constant.orange),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Constant.orange),
        ),
        contentPadding: const EdgeInsets.all(15),
        hintText: 'ପାସୱର୍ଡ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        color: Constant.orange,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            _loggedInUser = await userAPI().signIn(
                emailController.text.trim(), passswordController.text.trim());

            print("Name: ${_loggedInUser?.name}");
            if (_loggedInUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    loggedInUser: _loggedInUser,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 6,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'ଦୟା କରି ନିଜ ଇ-ମେଲ କିମ୍ବା ପାସୱର୍ଡ ପୁନଃ ଯାଞ୍ଚ କରନ୍ତୁ',
                    style: TextStyle(color: Constant.white),
                  ),
                  backgroundColor: Constant.orange,
                ),
              );
            }
          }
        },
        child: Text(
          "ଲଗ ଇନ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final resetPassword = TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword()));
      },
      child: const Text(
        'ପାସୱର୍ଡ ଭୁଲିଯାଇଛନ୍ତି ?',
        style: TextStyle(
          color: Constant.orange,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // logo
                        const Image(
                          image: AssetImage('assets/image/listen.png'),
                        ),
                        const SizedBox(height: 20),
                        emailField,
                        const SizedBox(height: 20),
                        passwordField,
                        const SizedBox(height: 20),
                        resetPassword,
                        const SizedBox(height: 10),
                        loginButton,
                        // const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text('ଆକାଉଣ୍ଟ ନାହିଁ ?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()),
                                  );
                                },
                                child: const Text(
                                  'ସାଇନ ଅପ',
                                  style: TextStyle(
                                    color: Constant.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
