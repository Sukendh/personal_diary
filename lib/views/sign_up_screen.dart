import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var divWidth;
  bool _autoValidate = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _firstNameTextController =
  new TextEditingController();
  final TextEditingController _lastNameTextController =
  new TextEditingController();
  final TextEditingController _phoneTextController =
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
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
    );
  }

  Widget _buildEmailSignUpForm() {
    //Form 1
    return new Column(
      children: <Widget>[
        new Container(
          height: 51.0,
          width: 144.0,
          child: new Container(),
        ),
        new Container(
            margin: EdgeInsets.only(
                top: 50.0, left: kMarginPadding, right: kMarginPadding),
            child: new Text(
              "Sign up ",
              maxLines: 1,
            )),
        new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: kMarginPadding, right: 10.0),
                  child: new TextFormField(
                      style: new TextStyle(
                          fontSize: kFontSize, color: Colors.blueGrey),
                      controller: _firstNameTextController,
                      validator: _validateFields,
                      decoration: InputDecoration(
                          labelText: "First Name*",
                          hintText: "Enter your first name",
                          labelStyle: new TextStyle(fontSize: kFontSize))),
                )),
            new Expanded(
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 10.0, right: kMarginPadding),
                  child: new TextFormField(
                      style: new TextStyle(
                          fontSize: kFontSize, color: Colors.blueGrey),
                      controller: _lastNameTextController,
                      validator: _validateFields,
                      decoration: InputDecoration(
                          labelText: "Last name",
                          hintText: "Enter your last name",
                          labelStyle: new TextStyle(fontSize: kFontSize))),
                ))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          padding: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new TextFormField(
              style: new TextStyle(
                  fontSize: kFontSize, color: Colors.blueGrey),
              controller: _phoneTextController,
              inputFormatters: [
                new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,|\\-]')),
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.length == 0) {
                  return "Please enter your phone number";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Phone number",
                  hintText: "Enter phone number",
                  labelStyle: new TextStyle(fontSize: kFontSize))),
        ),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          padding: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new TextFormField(
              style: new TextStyle(
                  fontSize: kFontSize, color: Colors.blueGrey),
              obscureText: true,
              controller: _passwordTextController,
              validator: (value) {
                if (value.length == 0) {
                  return "Password is not valid";
                } else if (value.length < 6) {
                  return "Please enter atleast 6 characters";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Password*",
                  hintText: "Enter a password",
                  labelStyle: new TextStyle(fontSize: kFontSize))),
        ),
        SizedBox(
          height: 10.0,
        ),
        new RaisedButton(
          child: new Text("Sign Up"),
          onPressed: () => _signUpButtonTaped(),
        ),
      ],
    );
  }

  String _validateFields(String text) {
    if (text.length == 0) {
      return "Should not be empty";
    } else {
      return null;
    }
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
