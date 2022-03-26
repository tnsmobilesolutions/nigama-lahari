import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/API/userAPI.dart';

import 'package:flutter_application_1/home_screen.dart';

import '../constant.dart';

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
    final name = TextFormField(
      style: TextStyle(color: Constant.white),
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
        contentPadding: const EdgeInsets.all(15),
        labelText: 'ନାମ',
        labelStyle: TextStyle(fontSize: 15.0, color: Constant.white12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.white),
        ),
      ),
    );
    final mobileNumber = TextFormField(
      style: TextStyle(color: Constant.white),
      autofocus: false,
      controller: _mobileController,
      keyboardType: TextInputType.number,
      validator: (value) {
        // Returns true if Phone Number address is in use.

        if (value == null || value.isEmpty) {
          return ("Please enter Your Phone Number");
        }
        // reg expression for email validation
        else if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ("Please enter 10 Digit Phone Number");
        }
        //else if () {}
        return null;
      },
      onSaved: (value) {
        _mobileController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        labelText: 'Phone Number',
        labelStyle: TextStyle(fontSize: 15.0, color: Constant.white12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.white),
        ),
      ),
    );

    final email = TextFormField(
      style: TextStyle(color: Constant.white),
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
        contentPadding: const EdgeInsets.all(15),
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 15.0, color: Constant.white12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.white),
        ),
      ),
    );
    final password = TextFormField(
      style: TextStyle(color: Constant.white),
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
        contentPadding: const EdgeInsets.all(15),
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: 15.0, color: Constant.white12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.white),
        ),
      ),
    );

    final confirmPassword = TextFormField(
      style: TextStyle(color: Constant.white),
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
        contentPadding: const EdgeInsets.all(15),
        labelText: 'Confirm Password',
        labelStyle: TextStyle(fontSize: 15.0, color: Constant.white12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Constant.white),
        ),
      ),
    );
    final signUpButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Constant.orange),
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          final _appUser = await userAPI().signUp(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
              _mobileController.text);

          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).iconTheme.color,
            behavior: SnackBarBehavior.floating,
            content: const Text('Account created successfully'),
          );
          await ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                loggedInUser: _appUser,
              ),
            ),
          );
        }
      },
      child: Text(
        "SignUp",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    return Container(
      child: Scaffold(
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
