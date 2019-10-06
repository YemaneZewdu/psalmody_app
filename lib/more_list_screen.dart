import 'package:flutter/material.dart';

class MoreListScreen extends StatelessWidget {
  final _moreOptions = [
    "Learn Geez",
    "How to use the App",
    "Settings",
    "About Psalmody"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(_moreOptions[0]),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text(_moreOptions[1]),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(_moreOptions[2]),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(_moreOptions[3]),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
