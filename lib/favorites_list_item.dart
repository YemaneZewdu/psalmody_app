import 'package:flutter/material.dart';

class FavoritesListItem extends StatefulWidget {
  @override
  _FavoritesListItemState createState() => _FavoritesListItemState();
}

class _FavoritesListItemState extends State<FavoritesListItem> {
  List<String> _favorites = [
    "Favorites 1",
    "Favorites 2",
    "Favorites 3",
    "Favorites 4",
    "Favorites 5"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: ListTile(
                title: Text(
                  _favorites[index],
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.6,
                  ),
                ),
                trailing: Icon(Icons.star),
              ),
            ),
          ),
        );
      },
    ));
  }
}
