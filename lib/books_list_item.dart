import 'package:flutter/material.dart';

class BooksListItem extends StatelessWidget {
  final _books = ["Book 1", "Book 2", "Book 3"];
  final _booksDescription = ["description 1", "description 2", "description 3"];

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
                    _books[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.6,
                    ),
                  ),
                  subtitle: Text(
                    _booksDescription[index],
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
