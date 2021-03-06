import 'package:flutter/material.dart';
import 'package:personal_diary/app_utils/app_utils.dart';
import 'package:personal_diary/firestore/firestore_services.dart';
import 'package:personal_diary/plugins_utils/GoogleSignin.dart';
import 'package:personal_diary/views/diary_home.dart';
import 'package:personal_diary/views/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var divWidth;
  bool _autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailTextController =
      new TextEditingController();
  final TextEditingController _passwordTextController =
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
      key: _scaffoldKey,
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

  Widget _buildEmailSignUpForm() {
    //Form 1
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
          height: 20.0,
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
                  hintText: "Enter your password",
                  labelStyle: new TextStyle(fontSize: 13))),
        ),
        SizedBox(
          height: 20.0,
        ),
        OutlineButton(
          splashColor: Colors.grey,
          onPressed: () => _loginButtonTapped(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
          child: _signInButton(),
        ),
        new FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: new Text(
              'Create an account',
              style: new TextStyle(color: Colors.black54, fontSize: 18.0),
            )),
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

  _loginButtonTapped() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      GoogleSigninUtils()
          .SigninUserWithUsernameAndPassowrd(
              _emailTextController.text, _passwordTextController.text)
          .then((result) {
        if (result != null) {
          AppUtils.showSnackBar(_scaffoldKey, 'Signed in...');
          var map = {
            'username': _emailTextController.text.trim().toString(),
            'password': _passwordTextController.text.trim().toString()
          };
          FirestoreServices().createUser(map, result.uid);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DiaryHome()));
        } else {
          AppUtils.showSnackBar(_scaffoldKey, 'Sign in error...');
        }
      });
    }
  }

  _googleSignInTapped() {
    GoogleSigninUtils().signInWithGoogle().then((user) {
      if (user.getIdToken() != false) {
        AppUtils.showSnackBar(_scaffoldKey, 'Signed in...');
        var map = {
          'username': user.email,
          'password': user.uid
        };
        FirestoreServices().createUser(map, user.uid);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiaryHome()));
      } else {
        AppUtils.showSnackBar(_scaffoldKey, 'Sign in error...');
      }
    });
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => _googleSignInTapped(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
