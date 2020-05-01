import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterChipTag extends StatefulWidget{
  final String chipName;

  FilterChipTag({Key key, this.chipName}) : super(key:key);

  @override
  _FilterChipTagState createState() => _FilterChipTagState();
}

class _FilterChipTagState extends State<FilterChipTag> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(widget.chipName),
        labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
        padding: EdgeInsets.all(3.0),
    );
  }

  Widget getChip(String name) {
    return FilterChip(
      label: Text(name),
      labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
      padding: EdgeInsets.all(3.0),
      selected: _isSelected,
      onSelected: (selected) {
        setState(() {
          _isSelected = selected;
        });
      },
      selectedColor: Colors.blueAccent);
  }

}