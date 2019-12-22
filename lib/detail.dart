import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  var index = -1;
  Detail({this.index});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Row(
          children: [
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to first route when tapped.
            },
            child: Text('Cancel'),
          ),
          RaisedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
            },
            child: Text('Save'),
          ),],
        ),
      ),
    );
  }
}