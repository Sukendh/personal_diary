import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';

class DiarySearch extends SearchDelegate<Dairy> {
  final List<Dairy> diaries;
  List<Dairy> filteredDiary = [];
  DiarySearch({this.diaries});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
        hintColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ));
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Enter a note to search.',
                  style: TextStyle(color: Colors.black),
                )
              ],
            )),
      );
    } else {
      filteredDiary = [];
      getFilteredList(diaries);
      if (filteredDiary.length == 0) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.sentiment_dissatisfied,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'No results found',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredDiary.length == null ? 0 : filteredDiary.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredDiary[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  filteredDiary[index].description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () {
                  close(context, filteredDiary[index]);
                },
              );
            },
          ),
        );
      }
    }
  }

  List<Dairy> getFilteredList(List<Dairy> note) {
    for (int i = 0; i < note.length; i++) {
      if (note[i].title.toLowerCase().contains(query) ||
          note[i].description.toLowerCase().contains(query) ||
          note[i].date.toLowerCase().contains(query)) {
        filteredDiary.add(note[i]);
      }
    }
    return filteredDiary;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Enter a note to search.',
                  style: TextStyle(color: Colors.black),
                )
              ],
            )),
      );
    } else {
      filteredDiary = [];
      getFilteredList(diaries);
      if (filteredDiary.length == 0) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.sentiment_dissatisfied,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'No results found',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredDiary.length == null ? 0 : filteredDiary.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredDiary[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  filteredDiary[index].description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () {
                  close(context, filteredDiary[index]);
                },
              );
            },
          ),
        );
      }
    }
  }
}