import 'package:flutter/material.dart';
import 'package:personal_diary/add_diary_screen.dart';

import 'design_course_app_theme.dart';

class DiaryHomeScreen extends StatefulWidget {
  @override
  _DiaryHomeScreenState createState() => _DiaryHomeScreenState();
}

class _DiaryHomeScreenState extends State<DiaryHomeScreen> {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Material(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, position) {
              return diaryItem();
            },
          ),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: new Color(0xFFE57373),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDiaryScreen()));
              })),
    );
  }

  Widget diaryItem() {
    return new Card(
      child: new Text("helloe"),
    );
  }
}
