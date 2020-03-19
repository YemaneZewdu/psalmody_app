import 'package:flutter/material.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
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
        backgroundColor: Color(0xffEBEFF2),
        body: new ListView.builder(
          itemCount: _favorites.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
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
