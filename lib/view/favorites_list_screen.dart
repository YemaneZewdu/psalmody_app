import 'package:flutter/material.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/sqflite/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psalmody/models/favorites.dart';
import 'audio_player_screen.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  Mezmur mezmurData;
  Future<List<Favorites>> favoritesList;

  final databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    getFavListFromDatabase();
  }

  // get the favorites list
  getFavListFromDatabase() {
    setState(() {
      favoritesList = databaseHelper.getFavorites();
    });
  }

//  Future<void> loadPrefs({int index}) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    favs = preferences.getKeys();
//    favList = preferences.get(favs.elementAt(index));
//  }
//
//  int getFavKeysLength() => favs.length;

  futureWidget(BuildContext context) => FutureBuilder<List<Favorites>>(
        future: favoritesList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "Loading Favorites...",
                style: TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text(
                "No Favorites yet!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return ListView.builder(

              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        mezmurData: mezmurData,
                        weekIndex: snapshot.data[index].weekIndex,
                      ),
                    ),
                  ),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        // text padding
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              misbakChapter(
                                  snapshot.data[index].misbakChapters),
                              SizedBox(width: 15),
                              displayFavoritesMisbakLines(
                                  snapshot.data[index], index),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      );

  // returns misbak chapters
  Widget misbakChapter(String chapters) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 25.0),
              Text(
                "ምስባክ፥",
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(chapters),
            ],
          )
        ],
      );

  // returns misbak lines
  Widget displayFavoritesMisbakLines(Favorites favs, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          favs.misbakLine1 + "\n" + favs.misbakLine2 + "\n" + favs.misbakLine3,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300], body: futureWidget(context));
  }
}
