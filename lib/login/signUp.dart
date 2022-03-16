import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/API/userAPI.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_application_1/home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value of the TextField.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const photo = Image(
      image: AssetImage('assets/image/circle_avatar.gif'),
      height: 100,
      width: 100,
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
    final mobileNumber = IntlPhoneField(
        validator: (value) {
          RegExp regex = new RegExp(r'^.{10,}$');
          if (value == null || value.isEmpty) {
            return ("Please enter your phone number");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter a valid number(Min. 10 Character)");
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
        onChanged: (phone) {});

    final email = TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        // Returns true if email address is in use.

        if (value == null || value.isEmpty) {
          return ("Please enter Your Email");
        }
        // reg expression for email validation
        else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please enter a valid email");
        }
        //else if () {}
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
      ),
    );
    final password = TextFormField(
        autofocus: false,
        controller: _passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value == null || value.isEmpty) {
            return ("Password length must be atleast 6 characters");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password (min 6 character)");
          } else if (value.length < 6) {
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
      obscureText: true,
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
      color: Colors.purple,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              await userAPI().signUp(
                  _emailController.text,
                  _passwordController.text,
                  _nameController.text,
                  _mobileController.text);
              await Fluttertoast.showToast(
                  msg: "Account created successfully :) ");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            }
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.teal],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              //color: Colors.white,
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
                        mobileNumber,
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
      ),
    );
  }
}
