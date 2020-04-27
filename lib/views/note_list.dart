import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:personal_diary/app_utils/widgets.dart';
import 'package:personal_diary/db_helper/db_helper.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/views/search_note.dart';
import 'package:sqflite/sqflite.dart';

import 'diary_detail.dart';

class DiaryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiaryListState();
  }
}

class DiaryListState extends State<DiaryList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Dairy> diaryList;
  int count = 0;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (diaryList == null) {
      diaryList = List<Dairy>();
      updateListView();
    }

    Widget myAppBar() {
      return AppBar(
        title: Text('Notes', style: Theme.of(context).textTheme.headline),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: diaryList.length == 0
            ? Container()
            : IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () async {
            final Dairy result = await showSearch(
                context: context, delegate: DiarySearch(diaries: diaryList));
            if (result != null) {
              navigateToDetail(result, 'Edit Note');
            }
          },
        ),
        actions: <Widget>[
          diaryList.length == 0
              ? Container(

          )
              : IconButton(
            icon: Icon(
              axisCount == 2 ? Icons.list : Icons.grid_on,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                axisCount = axisCount == 2 ? 4 : 2;
              });
            },
          )
        ],
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: diaryList.length == 0
          ? Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Click on the add button to add a new note!',
                style: Theme.of(context).textTheme.body1),
          ),
        ),
      )
          : Container(
        color: Colors.white,
        child: getNotesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Dairy('', '', 3, 0), 'Add Note');
        },
        tooltip: 'Add Note',
        shape: CircleBorder(side: BorderSide(color: Colors.black, width: 2.0)),
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToDetail(this.diaryList[index], 'Edit Note');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: colors[this.diaryList[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          this.diaryList[index].title,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                    ),
                    Text(
                      getPriorityText(this.diaryList[index].priority),
                      style: TextStyle(
                          color: getPriorityColor(
                              this.diaryList[index].priority)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            this.diaryList[index].description == null
                                ? ''
                                : this.diaryList[index].description,
                            style: Theme.of(context).textTheme.body2),
                      )
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(this.diaryList[index].date,
                          style: Theme.of(context).textTheme.subtitle),
                    ])
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.green;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '!!!';
        break;
      case 2:
        return '!!';
        break;
      case 3:
        return '!';
        break;

      default:
        return '!';
    }
  }

  // void _delete(BuildContext context, Note note) async {
  //   int result = await databaseHelper.deleteNote(note.id);
  //   if (result != 0) {
  //     _showSnackBar(context, 'Note Deleted Successfully');
  //     updateListView();
  //   }
  // }

  // void _showSnackBar(BuildContext context, String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void navigateToDetail(Dairy note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Dairy>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.diaryList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}