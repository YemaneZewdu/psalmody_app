import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/sqflite/database_helper.dart';
import 'package:psalmody/view/favorites_bloc.dart';
import 'audio_player_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {

  // reference to the class that manages the database
  final databaseHelper = DatabaseHelper.instance;
  // used for setting up a snack bar
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // snack bar for notifying the user that the favorite was removed
  final SnackBar mezmurRemovedFromFavorites = SnackBar(
    content: Text("Removed from Favorites List"),
    behavior: SnackBarBehavior.floating,
    elevation: 6.0,
  );
  // controls the slidable
  final SlidableController slidableController = SlidableController();

  final favBloc = FavoritesBloc();


  @override
  void initState() {
    super.initState();
   }

  @override
  void dispose(){
    favBloc.dispose();
    super.dispose();
  }


  void showSnackBar() =>
      scaffoldKey.currentState.showSnackBar(mezmurRemovedFromFavorites);

  // deletes the specific favorite from the sqflite db
  Future<void> _swipeDelete(BuildContext context, String mezmurName) async {
    try {
      favBloc.delete(mezmurName);
    } catch (e) {
      CupertinoAlertDialog(
        content: Text("Something went wrong. Please try again."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              "Ok",
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }

  // displays an alert dialog box to confirm if the user really wants to delete the favorite
  Future<bool> confirmDelete(BuildContext context, String mezmurName) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text("Are you sure you want to delete?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // call delete function in db class
                  _swipeDelete(context, mezmurName);
                  // show snack bar
                  showSnackBar();
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  // Dismiss the dialog but don't
                  // dismiss the swiped item
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  // lets users share or copy to clipboard
  void share(WeekMezmurList fav) {
    //TODO: Enter the app store link of the app in the subject field
    Share.share(
      "ምስባክ፥ ${fav.misbakChapters}\n${fav.misbakLine1}\n${fav.misbakLine2}\n${fav.misbakLine2}");
  }

  // builds the favorites list, if there is/are any or displays an appropriate message
  favListBuilder(BuildContext context) {
    return StreamBuilder<List<WeekMezmurList>>(
      stream: favBloc.favStream,
      builder: (context, AsyncSnapshot<List<WeekMezmurList>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
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
                onTap: () =>
                // rootNavigator will make the bottom nav disappear
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            AudioPlayerScreen(
                              weeklyList: snapshot.data[index],
//                              mezmurName: snapshot.data[index].mezmurName,
                              weekIndex: snapshot.data[index].weekId,
//                              misbakChapters: snapshot.data[index]
//                                  .misbakChapters,
//                              misbakLine1: snapshot.data[index].misbakLine1,
//                              misbakLine2: snapshot.data[index].misbakLine2,
//                              misbakLine3: snapshot.data[index].misbakLine3,
//                              misbakPictureRemoteUrl: snapshot.data[index]
//                                  .misbakPictureRemoteUrl,
//                              misbakAudioUrl: snapshot.data[index]
//                                  .misbakAudioUrl,
//                              misbakPicturelocalPath: snapshot.data[index]
//                                  .misbakPicturelocalPath,
                              favoritesBloc: favBloc,
                            ),
                      ),
                    ),
                child: Slidable(
                  key: new Key(snapshot.data[index].mezmurName),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  // closes other active slidable if there is any
                  controller: slidableController,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.indigo,
                      icon: CupertinoIcons.share,
                      onTap: () =>
                          share(snapshot
                              .data[index]),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () =>
                          confirmDelete(
                              context, snapshot.data[index].mezmurName),
                    ),
                  ],
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
                ),
              );
            },
          );
        }
      },
    );
  }

  // returns misbak chapters numbers
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

  // returns the 3 misbak lines
  Widget displayFavoritesMisbakLines(WeekMezmurList favs, int index) => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              favs.misbakLine1 +
                  "\n" +
                  favs.misbakLine2 +
                  "\n" +
                  favs.misbakLine3,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Favorites"),
        ),
        key: scaffoldKey,
        backgroundColor: Colors.grey[300],
        body: favListBuilder(context),
      ),
    );
  }
}
