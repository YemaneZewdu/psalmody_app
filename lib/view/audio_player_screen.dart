import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/favorites.dart';
import 'package:psalmody/sqflite/database_helper.dart';
//import 'package:vector_math/vector_math_64.dart' show Vector3;

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();

  final int weekIndex;
  final Mezmur mezmurData;

  AudioPlayerScreen({
    Key key,
    this.weekIndex,
    this.mezmurData,
  }) : super(key: key);
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isFavoriteButtonPressed = false;
  bool isInFavoritesList = false;
  double sliderValue = 0.0;
  // reference to our single class that manages the database
  final databaseHelper = DatabaseHelper.instance;
  Favorites favoritesObj;

  //double scale = 1.0;
  // double previousScale = 1.0;

  // used for setting up a snack bar
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final SnackBar mezmurAddedToFavorites =
      SnackBar(content: Text("Added to Favorites"));

  final SnackBar mezmurAddedRemovedFromFavorites =
      SnackBar(content: Text("Removed from Favorites"));

  @override
  void initState() {
    super.initState();
    // calling the function so that 'isInFavoritesList' will get its value
    checkFavoritesList(
        mezmurName:
            widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName);
    initFavoritesObject();
  }

  // initializes fav object with the current data, used for adding or deleting in the db
  void initFavoritesObject() {
    setState(() {
      favoritesObj = Favorites(
          mezmurName:
              widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName,
          weekIndex: widget.weekIndex,
          misbakChapters:
              widget.mezmurData.weekMezmurList[widget.weekIndex].misbakChapters,
          misbakLine1:
              widget.mezmurData.weekMezmurList[widget.weekIndex].misbakLine1,
          misbakLine2:
              widget.mezmurData.weekMezmurList[widget.weekIndex].misbakLine2,
          misbakLine3:
              widget.mezmurData.weekMezmurList[widget.weekIndex].misbakLine3);
    });
  }

  void checkFavoritesList({String mezmurName}) async {
    // check if mezmur is in favorites list with mezmurName as a key
    bool newVal = await databaseHelper.inFavorites(mezmurName: mezmurName);
    setState(() {
      isInFavoritesList = newVal;
    });
  }

  // slider controller
  void onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  // if the favorite button is tapped, show the appropriate snack bar
  void showSnackBar() =>  !isInFavoritesList
      ? scaffoldKey.currentState.showSnackBar(mezmurAddedToFavorites)
      : scaffoldKey.currentState.showSnackBar(mezmurAddedRemovedFromFavorites);


  void manageFavorites() async {
    if (isInFavoritesList) {
      // if true, the mezmur is already in favorites list. i.e remove it
      databaseHelper.delete(
          mezmurName:
              widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName);
      checkFavoritesList(
          mezmurName:
              widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName);
    } else {
      // if false, add it to favorites list
      databaseHelper.insertToDb(favoritesObj);
      // calling the function so that it will set  'isInFavoritesList' to true
      checkFavoritesList(
          mezmurName:
              widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName);
    }
  }
  counter () async {
    int length = await databaseHelper.queryRowCount();
    print("******");
    print(length);
    print("******");
  }
  @override
  Widget build(BuildContext context) {
    // variables for getting custom screen height and width
    //var customScreenWidth = MediaQuery.of(context).size.width / 100;
    var customScreenHeight = MediaQuery.of(context).size.height / 100;
    String errorMessage = "Error! Click Here to relod";
    // custom placeholder widget
    Widget customPlaceHolder() {
      return Center(
        child: CircularProgressIndicator(),
      );
    }


    //TODO: *********************Download image to phone or share it***************************
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName,
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          // favorites icon button
          IconButton(
            icon: Icon(isInFavoritesList ? Icons.star : Icons.star_border),
            onPressed: () {
              manageFavorites();
              showSnackBar();
              counter();
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
            //margin: EdgeInsets.only(top: 35),
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
//              onScaleStart: (ScaleStartDetails details) {
//                previousScale = scale;
//                setState(() {});
//              },
//              onScaleUpdate: (ScaleUpdateDetails details) {
//                scale = previousScale * details.scale;
//                setState(() {});
//              },
//              onScaleEnd: (ScaleEndDetails details) {
//                // assigning it back to 1.0 to leave the image zoomed
//                previousScale = 1.0;
//              },
              // allows the image to be move when zoomed
//              child: Transform(
              // this alignment makes it zoomed from the center
//                alignment: FractionalOffset.,
//                transform: Matrix4.diagonal3(
//                  Vector3(scale, scale, scale),
//                ),

              child: CachedNetworkImage(
                alignment: Alignment.center,
                imageUrl: widget.mezmurData.weekMezmurList[widget.weekIndex]
                    .misbakPictureUrl,
                placeholder: (context, url) => customPlaceHolder(),
                errorWidget: (context, url, error) => FlatButton(
                  // used a container because the flat button is sized as the image size
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // makes a network call again
                  onPressed: () => setState(() {}),
                ),
              ),
            ),
          ),

          // Playing buttons container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 110,
              margin: EdgeInsets.all(10),
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(1.0, 2.0),
                    blurRadius: 15.0,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 5),
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("1:05"),
                        Slider(
                          onChanged: onSliderChanged,
                          value: sliderValue,
                          activeColor: Colors.grey[700],
                          inactiveColor: Colors.grey[400],
                        ),
                        Text("-0:50"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 35),
                      //padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.replay_5,
                              color: Colors.black,
                            ),
                            iconSize: 35,
                            onPressed: null,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: Colors.black,
                            ),
                            iconSize: 40,
                            onPressed: null,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.forward_5,
                              color: Colors.black,
                            ),
                            iconSize: 35,
                            onPressed: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
