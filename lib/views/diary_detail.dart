import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_diary/app_utils/chip_tag.dart';
import 'package:personal_diary/app_utils/widgets.dart';
import 'package:personal_diary/db_helper/db_helper.dart';
import 'package:personal_diary/firestore/firestore_services.dart';
import 'package:personal_diary/models/diary.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Dairy diary;

  NoteDetail(this.diary, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.diary, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Dairy note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  int color;
  bool isEdited = false;
  DateTime _selectedDate;
  List<String> tagsList = List<String>();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  void initState() {
    if (note.date != '') {
      _selectedDate = DateFormat.yMMMd().parse(note.date);
    } else {
      _selectedDate = DateTime.now();
    }
    if (note.tags != null) {
      tagsList = note.tags;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return WillPopScope(
        onWillPop: () {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.title,
            ),
            backgroundColor: colors[color],
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: () {
                  titleController.text.length == 0
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              color: colors[color],
              child: Column(
                children: <Widget>[
                  PriorityPicker(
                    selectedIndex: 3 - note.priority,
                    onTap: (index) {
                      isEdited = true;
                      note.priority = 3 - index;
                    },
                  ),
                  ColorPicker(
                    selectedIndex: note.color,
                    onTap: (index) {
                      setState(() {
                        color = index;
                      });
                      isEdited = true;
                      note.color = index;
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2001),
                              lastDate: DateTime(2222))
                          .then((date) {
                        setState(() {
                          if (date != null) {
                            _selectedDate = date;
                          }
                        });
                      });
                    },
                    child: Container(
                      width: 180.0,
                      height: 40.0,
                      margin: EdgeInsets.only(top: 10.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(
                                20.0) //         <--- border radius here
                            ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            DateFormat.yMMMd().format(_selectedDate),
                            style: new TextStyle(
                                fontSize: 19.0, color: Colors.blueGrey),
                          ),
                          new Icon(
                            Icons.calendar_today,
                            color: Colors.blueGrey,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller: titleController,
                      maxLength: 255,
                      style: Theme.of(context).textTheme.body1,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Title',
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        maxLength: 255,
                        controller: descriptionController,
                        style: Theme.of(context).textTheme.body2,
                        onChanged: (value) {
                          updateDescription();
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Description',
                        ),
                      ),
                    ),
                  ),
                  new Wrap(
                    children: tagsList.map((item) =>  FilterChipTag(chipName: item)).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: new Text('Add tags', style: TextStyle(fontSize: 16.0, color: Colors.black54),),
                  ),),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(13.0),
                            bottomLeft: Radius.circular(13.0),
                            topLeft: Radius.circular(13.0),
                            topRight: Radius.circular(13.0),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: TextFormField(
                                  controller: tagController,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  validator: (value) {
                                    if (value != "") {
                                      return null;
                                    } else {
                                      return 'is empty';
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.add_circle_outline, size: 30.0, color: Colors.grey),
                              ),
                              onTap: () {
                                setState(() {
                                  tagsList.add(tagController.text.trim());
                                  tagController.clear();
                                });
                              },
                            ),
                            GestureDetector(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(Icons.clear, size: 30.0, color: Colors.grey),
                              ),
                              onTap: () {
                                setState(() {
                                  tagsList.clear();
                                  tagController.clear();
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Are you sure you want to discard changes?",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Title is empty!",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text('The title of the note cannot be empty.',
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(_selectedDate);
    note.tags = tagsList;

    if (note.id != null) {
      //await helper.updateNote(note);
      FirestoreServices().update(note.toMap());
    } else {
      note.id = DateTime.now().millisecondsSinceEpoch;
      FirestoreServices().add(note.toMap());
      //await helper.insertNote(note);
    }
  }

  void _delete() async {
    //await helper.deleteNote(note.id);
    FirestoreServices().delete(note.id.toString());
    moveToLastScreen();
  }
}
