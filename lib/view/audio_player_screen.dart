import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/week_mezmur_list.dart';

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
  double sliderValue = 0.0;
  List<WeekMezmurList> favoritesList = new List<WeekMezmurList>();

  // used for setting up a snack bar
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final SnackBar mezmurAddedToFavorites =
      SnackBar(content: Text("Added to Favorites"));

  final SnackBar mezmurAddedRemovedFromFavorites =
      SnackBar(content: Text("Removed from Favorites"));

  // favorite icon button controller
  void _favButtonPressed() {
    bool newVal = true;
    if (isFavoriteButtonPressed) {
      newVal = false;
    } else {
      newVal = true;
    }
    setState(() {
      isFavoriteButtonPressed = newVal;
    });
  }

  // slider controller
  void onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  // if the favorite button is tapped, show the appropriate snack bar
  void showSnackBar() => isFavoriteButtonPressed
      ? scaffoldKey.currentState.showSnackBar(mezmurAddedToFavorites)
      : scaffoldKey.currentState.showSnackBar(mezmurAddedRemovedFromFavorites);

  void manageFavorites() {
    if (isFavoriteButtonPressed) {
      favoritesList.add(widget.mezmurData.weekMezmurList[widget.weekIndex]);
    }
    if (!isFavoriteButtonPressed && favoritesList.isNotEmpty) {
      favoritesList.remove(widget.mezmurData.weekMezmurList[widget.weekIndex]);
    }

    for (var i = 0; i < favoritesList.length; i++) {
      favoritesList.isNotEmpty ? print(favoritesList[i]) : print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    // variables for getting custom screen height and width
    var customScreenWidth = MediaQuery.of(context).size.width / 100;
    var customScreenHeight = MediaQuery.of(context).size.height / 100;

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
            icon:
                Icon(isFavoriteButtonPressed ? Icons.star : Icons.star_border),
            onPressed: () {
              _favButtonPressed();
              manageFavorites();
              showSnackBar();
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
              onTap: null,
              child: CachedNetworkImage(
                alignment: Alignment.center,
                imageUrl: widget.mezmurData.weekMezmurList[widget.weekIndex]
                    .misbakPictureUrl,
                placeholder: (context, url) => customPlaceHolder(),
                errorWidget: (context, url, error) => FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    child: Text(
                      "Error! Click to reload",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
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
