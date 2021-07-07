import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/sqflite/database_helper.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share/share.dart';
import 'favorites_bloc.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();

  final int? weekIndex;
  final Mezmur? mezmurData;
  final WeekMezmurList? weeklyList;
  FavoritesBloc? favoritesBloc;


  AudioPlayerScreen(
      {Key? key,
      this.weekIndex,
      this.mezmurData,
      this.weeklyList,
      this.favoritesBloc})
      : super(key: key);
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isInFavoritesList = false;

  // reference to the class that manages the database
  final databaseHelper = DatabaseHelper.instance;
  WeekMezmurList? favoritesObj;

  // used for setting up a snack bar
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final SnackBar mezmurAddedToFavorites =
      SnackBar(content: Text("Added to Favorites List"));

  final SnackBar mezmurRemovedFromFavorites =
      SnackBar(content: Text("Removed from Favorites List"));

  @override
  void initState() {
    super.initState();
    // calling the function so that 'isInFavoritesList' will get its value
    checkFavoritesList(
        mezmurName: widget.mezmurData != null
            ? widget.mezmurData!.weekMezmurList[widget.weekIndex!].mezmurName
            : widget.weeklyList!.mezmurName);
    initFavoritesObject();

  }

  // initializes fav object with the current data, used for adding or deleting in the db
  void initFavoritesObject() {
    setState(() {
      // mezmurData is null when coming from Favorite list screen
      // so checking it is necessary to avoid an error
      widget.mezmurData != null
          ? favoritesObj = WeekMezmurList(
              mezmurName:
                  widget.mezmurData!.weekMezmurList[widget.weekIndex!].mezmurName,
              weekId: widget.weekIndex,
              misbakChapters: widget
                  .mezmurData!.weekMezmurList[widget.weekIndex!].misbakChapters,
              misbakLine1: widget
                  .mezmurData!.weekMezmurList[widget.weekIndex!].misbakLine1,
              misbakLine2: widget
                  .mezmurData!.weekMezmurList[widget.weekIndex!].misbakLine2,
              misbakLine3: widget
                  .mezmurData!.weekMezmurList[widget.weekIndex!].misbakLine3,
              misbakAudioUrl: widget
                  .mezmurData!.weekMezmurList[widget.weekIndex!].misbakAudioUrl,
              misbakPictureRemoteUrl: widget.mezmurData!
                  .weekMezmurList[widget.weekIndex!].misbakPictureRemoteUrl,
              misbakPicturelocalPath: widget.mezmurData!
                  .weekMezmurList[widget.weekIndex!].misbakPicturelocalPath)
          : favoritesObj = WeekMezmurList(
              mezmurName: widget.weeklyList!.mezmurName,
              weekId: widget.weekIndex,
              misbakChapters: widget.weeklyList!.misbakChapters,
              misbakLine1: widget.weeklyList!.misbakLine1,
              misbakLine2: widget.weeklyList!.misbakLine2,
              misbakLine3: widget.weeklyList!.misbakLine3,
              misbakAudioUrl: widget.weeklyList!.misbakAudioUrl,
              misbakPictureRemoteUrl: widget.weeklyList!.misbakPictureRemoteUrl,
              misbakPicturelocalPath: widget.weeklyList!.misbakPicturelocalPath);
    });
  }

  void checkFavoritesList({String? mezmurName}) async {
    // check if mezmur is in favorites list with mezmurName as a key
    bool newVal = await databaseHelper.inFavorites(mezmurName: mezmurName);
    setState(() {
      isInFavoritesList = newVal;
    });
  }

  // if the favorite button is tapped, show the appropriate snack bar
  void showSnackBar() => !isInFavoritesList
      ? ScaffoldMessenger.of(context).showSnackBar(mezmurAddedToFavorites)
      : ScaffoldMessenger.of(context).showSnackBar(mezmurRemovedFromFavorites);

  void manageFavorites() async {
    // if true, the mezmur is already in favorites list. i.e remove it
    if (isInFavoritesList) {
      // mezmurData is null when coming from FavoriteList screen
      if (widget.mezmurData != null) {
        // delete using FavBloc class
        widget.favoritesBloc!.delete(
            widget.mezmurData!.weekMezmurList[widget.weekIndex!].mezmurName!);
        checkFavoritesList(
          mezmurName:
              widget.mezmurData!.weekMezmurList[widget.weekIndex!].mezmurName,
        );
      } else {
        widget.favoritesBloc!.delete(widget.weeklyList!.mezmurName!);
        checkFavoritesList(
          mezmurName: widget.weeklyList!.mezmurName,
        );
      }
    } else {
      // if false, add it to favorites list
      try {
        widget.favoritesBloc!.insert(favoritesObj!);
      } catch (e) {
       // print("Insert Error: ${e.toString()}");
      }
      // calling the function so that it will set  'isInFavoritesList' to true
      widget.mezmurData != null
          ? checkFavoritesList(
              mezmurName:
                  widget.mezmurData!.weekMezmurList[widget.weekIndex!].mezmurName,
            )
          : checkFavoritesList(
              mezmurName: widget.weeklyList!.mezmurName,
            );
    }
  }

//  counter() async {
//    int length = await databaseHelper.queryRowCount();
//    print("******");
//    print(length);
//    print("******");
//  }

  @override
  Widget build(BuildContext context) {
    // variables for getting custom screen height and width
    var customScreenWidth = MediaQuery.of(context).size.width / 100;
    var customScreenHeight = MediaQuery.of(context).size.height / 100;

    //TODO: *********************Download image to phone or share it***************************
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.mezmurData != null
                ? widget.mezmurData!.weekMezmurList[widget.weekIndex!].misbakChapters!
                : widget.weeklyList!.misbakChapters!,
            overflow: TextOverflow.fade,
          ),
          actions: <Widget>[
            // favorites icon button
          IconButton(
          icon: Icon(CupertinoIcons.share,),
          onPressed: () {
            Share.share(widget.mezmurData != null
                ? widget.mezmurData!.weekMezmurList[widget.weekIndex!].misbakPictureRemoteUrl!
                : widget.weeklyList!.misbakPictureRemoteUrl!);
          },
            iconSize: 35.0,
            color: Colors.black,),
            IconButton(
              icon: Icon(isInFavoritesList ? Icons.star : Icons.star_border),
              onPressed: () {
                manageFavorites();
                showSnackBar();
                //counter();
              },
              iconSize: 35.0,
              color: Colors.black,
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // network image container
            Container(
              height: customScreenHeight * 60,
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(
                child: Image.asset(
                  widget.mezmurData != null
                      ? widget.mezmurData!.weekMezmurList[widget.weekIndex!]
                          .misbakPicturelocalPath!
                      : widget.weeklyList!.misbakPicturelocalPath!,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 5, bottom: 25, top: 5, right: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.all(10),
                  width: customScreenWidth * 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 15.0,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

