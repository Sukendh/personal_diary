import 'package:flutter/material.dart';
import 'package:personal_diary/app_utils/app_utils.dart';
import 'package:personal_diary/models/diary_data.dart';
import 'package:personal_diary/views/add_diary_screen.dart';

import '../design_course_app_theme.dart';

class DiaryListView extends StatefulWidget {
  @override
  _DiaryListViewState createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<DiaryListView> {
  var diaryList = new DiaryList();
  var divWidth;

  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: diaryList.diary.length,
      itemBuilder: (context, position) {
        return diaryItem(position);
      },
    );
  }

  Widget diaryItem(int position) {
    return new Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 5.0),
      height: 120.0,
      child: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20.0),child: Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: divWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(diaryList.diary[position].title, style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0
                  ),),
                  new Text(diaryList.diary[position].content, style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey
                  ),)
                ],
              ),
            ),
          ),),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 35.0,
              width: 150.0,
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  new Text(diaryList.diary[position].day),
                  new Text(diaryList.diary[position].date)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
