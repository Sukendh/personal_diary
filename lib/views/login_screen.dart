import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var divWidth;
  bool _autoValidate = false;
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
          height: 50.0,
          width: 145.0,
          child: Icon(Icons.image, size: 100.0,),
        ),
        new Container(
          margin: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
          child: new Text(
            "Login here",
            maxLines: 1,
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
          child: _signInButton(),
        ),
//        new Container(
//          padding: EdgeInsets.only(left: 10.0, right: 10.0),
//          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
//          child: new TextFormField(
//              controller: _emailTextController,
//              validator: _validateEmail,
//              keyboardType: TextInputType.emailAddress,
//              decoration: InputDecoration(
//                  labelText: "Email*",
//                  hintText: "Enter your email",
//                  labelStyle: new TextStyle(fontSize: 13))),
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        new Container(
//          padding: EdgeInsets.only(left: 10.0, right: 10.0),
//          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
//          child: new TextFormField(
//              style: new TextStyle(
//                  fontSize: kMarginPadding, color: Colors.black38),
//              obscureText: true,
//              validator: (String value) {
//                if (value.isEmpty) {
//                  return "Please enter your password";
//                } else {
//                  return null;
//                }
//              },
//              controller: _passwordTextController,
//              decoration: InputDecoration(
//                  labelText: "Password*",
//                  hintText: "Enter a password",
//                  labelStyle: new TextStyle(fontSize: kFontSize))),
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        new RaisedButton(
//          onPressed: () => _loginButtonTapped(),
//          child: new Text("Login"),
//        ),
//        new FlatButton(
//            onPressed: () {
//
//            },
//            child: new Text(
//              'Forgot password',
//            )),
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

    }
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {},
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
