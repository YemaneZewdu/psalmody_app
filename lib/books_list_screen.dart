import 'package:flutter/material.dart';

class BooksListScreen extends StatelessWidget {
  final _books = [{'title':'Book 1', 'description':"description 1"} , {'title':'Book 2', 'description':"description 2"}, {'title':'Book 3', 'description':"description 3"}];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        itemCount: _books.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                child: ListTile(
                  title: Text(
                    _books[index]['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.6,
                    ),
                  ),
                  subtitle: Text(
                    _books[index]['description'],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
