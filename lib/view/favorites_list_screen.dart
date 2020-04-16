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
  // set for storing keys
  Set<String> favs = new Set<String>();
  Mezmur mezmurData;
  Map<String, String> favList = new Map<String, String>();
  Future<List<Favorites>> favoritesList;
  int currentFavId;
  final databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
  }

  // get the favorites list
  getFavListFromDatabase() {
    setState(() {
      favoritesList = databaseHelper.getFavorites();
    });
  }

  Future<void> loadPrefs({int index}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    favs = preferences.getKeys();
    favList = preferences.get(favs.elementAt(index));
  }

  int getFavKeysLength() => favs.length;

  futureWidget(BuildContext context) =>
      FutureBuilder(
        future: favoritesList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
             // getDataFromSnapshot(snapshot.data);
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                      onTap: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AudioPlayerScreen(
                                    mezmurData: mezmurData,
                                    weekIndex: index,
                                  ),
                            ),
                          ),
                      child: displayFavorites(snapshot.data)
                  );
                },
              );
            }
          }
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("No Favorites yet!"),
              ),
            );
          }
          return Container(
            child: Center(
              child: Text("Loading Favorites..."),
            ),
          );
        },
      );

  Widget displayFavorites(AsyncSnapshot snapshot) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          // text padding
          vertical: 15.0,
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[Text(snapshot.data.toString())],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: futureWidget(context)
    );
  }
}
