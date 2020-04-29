import 'package:flutter/material.dart';
import 'package:personal_diary/plugins_utils/GoogleSignin.dart';
import 'package:personal_diary/plugins_utils/SharedPreferences.dart';
import 'package:personal_diary/views/diary_home.dart';
import 'package:personal_diary/views/login_screen.dart';
import 'package:personal_diary/views/sign_up_screen.dart';

void main() {
  runApp(RootPage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          headline: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 24),
          body1: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20),
          body2: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 18),
          subtitle: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    GoogleSigninUtils().currentUser().then((user) {
      print('ROOOT PAGE ==== ${user}');
      if (user != null) {
        _authStatus = AuthStatus.signedIn;
      } else {
        _authStatus = AuthStatus.notSignedIn;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.signedIn:
        return DiaryHome();
      case AuthStatus.notSignedIn:
        return MyApp();
    }
  }

}
