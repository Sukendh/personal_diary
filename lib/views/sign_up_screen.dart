import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_diary/firestore/firestore_services.dart';
import 'package:personal_diary/plugins_utils/GoogleSignin.dart';
import 'package:personal_diary/plugins_utils/SharedPreferences.dart';

import 'diary_home.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var divWidth;
  bool _autoValidate = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailTextController =
  new TextEditingController();
  final TextEditingController _passwordTextController =
  new TextEditingController();
  final TextEditingController _confirmpasswordTextController =
  new TextEditingController();
  var kMarginPadding = 16.0;
  var kFontSize = 13.0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[_buildEmailSignUpForm()],
              )),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
    );
  }

  String _validateFields(String text) {
    if (text.length == 0) {
      return "Should not be empty";
    } else {
      return null;
    }
  }

  Widget _buildEmailSignUpForm() {
    //Form 1
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 50.0,
          width: 145.0,
          child: Icon(Icons.image, size: 100.0,),
        ),
        new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          child: new TextFormField(
              controller: _emailTextController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Email*",
                  hintText: "Enter your email",
                  labelStyle: new TextStyle(fontSize: 13))),
        ),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          child: new TextFormField(
              style: new TextStyle(
                  fontSize: kMarginPadding, color: Colors.black38),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please enter your password";
                } else {
                  return null;
                }
              },
              controller: _passwordTextController,
              decoration: InputDecoration(
                  labelText: "Password*",
                  hintText: "Enter a password",
                  labelStyle: new TextStyle(fontSize: kFontSize))),
        ),
        new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          child: new TextFormField(
              style: new TextStyle(
                  fontSize: kMarginPadding, color: Colors.black38),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please confirm your password";
                } else {
                  if (_passwordTextController.text == value) {
                    return null;
                  } else {
                    return "Password mismatching";
                  }
                }
              },
              controller: _confirmpasswordTextController,
              decoration: InputDecoration(
                  labelText: "Password*",
                  hintText: "Enter a password",
                  labelStyle: new TextStyle(fontSize: kFontSize))),
        ),
        SizedBox(
          height: 10.0,
        ),
        new RaisedButton(
          onPressed: () => _signUpButtonTapped(),
          child: new Text("Sign Up"),
        ),
      ],
    );
  }

  String _validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email))
      return null;
    else
      return "Please enter a valid email";
  }

  _signUpButtonTapped() {
    FocusScope.of(context).requestFocus(new FocusNode());

    GoogleSigninUtils().SignupUserWithUsernameAndPassowrd(_emailTextController.text.toString(), _passwordTextController.text.toString()).then((user) {
      var map = {
        'username': _emailTextController.text.trim().toString(),
        'password': _passwordTextController.text.trim().toString()};
      FirestoreServices().createUser(map, user.uid);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DiaryHome()));
    });

//    if (_formKey.currentState.validate()) {
//
//    }
  }

  _signUpButtonTaped() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //sign up user..

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
