import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/resetpasswordpage.dart';

import 'package:flutter_application_1/login/signUp.dart';
import 'package:flutter_application_1/API/userAPI.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passswordController = TextEditingController();

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
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    //password field
    final passwordField = TextFormField(
      obscureText: _obscureText,
      autofocus: false,
      controller: passswordController,

      //keyboardType: TextInputType.phone,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6}$');
        if (value!.isEmpty) {
          return "ନିଜ ପାସୱାଡ଼ ଲେଖନ୍ତୁ";
        }
        if (!regex.hasMatch(value)) {
          return "ଦୟା କରି ନିଜ ସଠିକ ପାସୱାଡ଼  ଲେଖନ୍ତୁ";
        }

        return null;
      },
      onSaved: (value) {
        passswordController.text = value!;
        ;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: new Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              await userAPI()
                  .signIn(emailController.text, passswordController.text);
              await Fluttertoast.showToast(msg: "LogIn successfull")
                  .whenComplete(() => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      )));
            }
            return null;
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final resetPassword = TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword()));
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.purple,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.white,
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
                          image: AssetImage('assets/image/pic.jpg'),
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
                              const Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'SignUp',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
