import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/login/usermodel.dart';
import 'package:flutter_application_1/nigamLahari/nigam_lahari.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value of the TextField.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const photo = CircleAvatar(
      radius: 50,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: Text('Add Your Photo'),
      ),
    );
    final name = TextFormField(
      autofocus: false,
      controller: _nameController,
      keyboardType: TextInputType.name,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter name';
        }
        return null;
      },
      onSaved: (value) {
        _nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final mobileNum = IntlPhoneField(
        validator: (value) {
          RegExp regex = new RegExp(r'^.{10,}$');
          if (value!.isEmpty) {
            return ("phone number cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 10 Character)");
          }
          return null;
        },
        onSaved: (value) {
          _mobileController.text = value!.toString();
        },
        controller: _mobileController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        initialCountryCode: 'IN',
        onChanged: (phone) {
          // print(phone.completeNumber);
        });

    // TextFormField(
    //   autofocus: false,
    //   controller: _mobileController,
    //   keyboardType: TextInputType.phone,
    //   maxLength: 10,
    //   inputFormatters: [
    //     FilteringTextInputFormatter.allow(
    //         RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')),
    //     //FilteringTextInputFormatter.deny(RegExp('[N()+-]')),
    //   ],
    //   validator: (value) {
    //     if (value == null || value.isEmpty) {
    //       return 'Please enter your number';
    //     } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
    //       return 'Please enter correct number';
    //     } else if (value.length < 10) {
    //       return 'Enter atleast 10 digits';
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     value = _mobileController.text;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(Icons.phone_android_rounded),
    //     contentPadding: const EdgeInsets.all(15),
    //     hintText: 'Phone Number',
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(15),
    //     ),
    //   ),
    // );
    final email = TextFormField(
        autofocus: false,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ("Please enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          _emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final password = TextFormField(
        autofocus: false,
        controller: _passwordController,
        //keyboardType: TextInputType.number,
        //obscureText: true,
        maxLength: 6,
        validator: (value) {
          //RegExp regex = new RegExp(r'^{6}$');
          if (value == null || value.isEmpty) {
            return ("Password length must be atleast 6 characters");
          }
          //   if (!regex.hasMatch(value)) {
          //     return ("Enter Valid Password (min 6 character)");
          //   } else
          else if (value.length < 6) {
            return 'Password length must be atleast 6 characters';
          }
          return null;
        },
        onSaved: (value) {
          _passwordController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final confirmPassword = TextFormField(
      autofocus: false,
      controller: _confirmPasswordController,
      //obscureText: true,
      validator: (value) {
        if (_confirmPasswordController.text != _passwordController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        _confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(_emailController.text, _passwordController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
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
                      name,
                      const SizedBox(height: 20),
                      mobileNum,
                      const SizedBox(height: 20),
                      email,
                      const SizedBox(height: 20),
                      password,
                      const SizedBox(height: 20),
                      confirmPassword,
                      const SizedBox(height: 20),
                      signUpButton
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError(
        (e) {
          Fluttertoast.showToast(msg: e!.message);
        },
      );
    }
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
    data.name = _nameController.text;
    data.mobile = _mobileController.text;

    await firebaseFirestore.collection("users").doc(user.uid).set(
          data.toMap(),
        );
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => NigamLahari()),
        (route) => false);
  }
}
