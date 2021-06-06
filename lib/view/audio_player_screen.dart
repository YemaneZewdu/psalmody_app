import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/sqflite/database_helper.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share/share.dart';
import 'favorites_bloc.dart';
//import 'package:vector_math/vector_math_64.dart' show Vector3;

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();

  final int weekIndex;
  final Mezmur mezmurData;
  final WeekMezmurList weeklyList;
  FavoritesBloc favoritesBloc;

  AudioPlayerScreen(
      {Key key,
      this.weekIndex,
      this.mezmurData,
      this.weeklyList,
      this.favoritesBloc})
      : super(key: key);
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isInFavoritesList = false;

//  double sliderValue = 0.0;

  // reference to the class that manages the database
  final databaseHelper = DatabaseHelper.instance;
  WeekMezmurList favoritesObj;
  AudioPlayer _player;

  //double scale = 1.0;
  // double previousScale = 1.0;

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
            ? widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName
            : widget.weeklyList.mezmurName);
    initFavoritesObject();
    _player = AudioPlayer();
    _player
        .setUrl(
            //"https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")
            "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3")
        .catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });
  }

  // initializes fav object with the current data, used for adding or deleting in the db
  void initFavoritesObject() {
    setState(() {
      // mezmurData is null when coming from Favorite list screen
      // so checking it is necessary to avoid an error
      widget.mezmurData != null
          ? favoritesObj = WeekMezmurList(
              mezmurName:
                  widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName,
              weekId: widget.weekIndex,
              misbakChapters: widget
                  .mezmurData.weekMezmurList[widget.weekIndex].misbakChapters,
              misbakLine1: widget
                  .mezmurData.weekMezmurList[widget.weekIndex].misbakLine1,
              misbakLine2: widget
                  .mezmurData.weekMezmurList[widget.weekIndex].misbakLine2,
              misbakLine3: widget
                  .mezmurData.weekMezmurList[widget.weekIndex].misbakLine3,
              misbakAudioUrl: widget
                  .mezmurData.weekMezmurList[widget.weekIndex].misbakAudioUrl,
              misbakPictureRemoteUrl: widget.mezmurData
                  .weekMezmurList[widget.weekIndex].misbakPictureRemoteUrl,
              misbakPicturelocalPath: widget.mezmurData
                  .weekMezmurList[widget.weekIndex].misbakPicturelocalPath)
          : favoritesObj = WeekMezmurList(
              mezmurName: widget.weeklyList.mezmurName,
              weekId: widget.weekIndex,
              misbakChapters: widget.weeklyList.misbakChapters,
              misbakLine1: widget.weeklyList.misbakLine1,
              misbakLine2: widget.weeklyList.misbakLine2,
              misbakLine3: widget.weeklyList.misbakLine3,
              misbakAudioUrl: widget.weeklyList.misbakAudioUrl,
              misbakPictureRemoteUrl: widget.weeklyList.misbakPictureRemoteUrl,
              misbakPicturelocalPath: widget.weeklyList.misbakPicturelocalPath);
    });
  }

  void checkFavoritesList({String mezmurName}) async {
    // check if mezmur is in favorites list with mezmurName as a key
    bool newVal = await databaseHelper.inFavorites(mezmurName: mezmurName);
    setState(() {
      isInFavoritesList = newVal;
    });
  }

  // if the favorite button is tapped, show the appropriate snack bar
  void showSnackBar() => !isInFavoritesList
      ? scaffoldKey.currentState.showSnackBar(mezmurAddedToFavorites)
      : scaffoldKey.currentState.showSnackBar(mezmurRemovedFromFavorites);

  void manageFavorites() async {
    // if true, the mezmur is already in favorites list. i.e remove it
    if (isInFavoritesList) {
      // mezmurData is null when coming from FavoriteList screen
      if (widget.mezmurData != null) {
        // delete using FavBloc class
        widget.favoritesBloc.delete(
            widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName);
        checkFavoritesList(
          mezmurName:
              widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName,
        );
      } else {
        widget.favoritesBloc.delete(widget.weeklyList.mezmurName);
        checkFavoritesList(
          mezmurName: widget.weeklyList.mezmurName,
        );
      }
    } else {
      // if false, add it to favorites list
      try {
        widget.favoritesBloc.insert(favoritesObj);
      } catch (e) {
        print("Insert Error: ${e.toString()}");
      }
      // calling the function so that it will set  'isInFavoritesList' to true
      widget.mezmurData != null
          ? checkFavoritesList(
              mezmurName:
                  widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName,
            )
          : checkFavoritesList(
              mezmurName: widget.weeklyList.mezmurName,
            );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    // widget.favoritesBloc.dispose();
    super.dispose();
  }

  // returns a two digit number for the audio minutes indicators
  String _printPosition({Duration position}) {
    String twoDigitsSec(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitsMin(int n) {
      if (n >= 10) return "$n";
      return "$n";
    }

    String twoDigitMinutes = twoDigitsMin(position.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigitsSec(position.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // builds the slider with a position and a duration indicator text numbers under it
  Widget sliderBuilder(var customScreenWidth) {
    return StreamBuilder<Duration>(
      stream: _player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: _player.getPositionStream(),
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            if (position > duration) {
              position = duration;
            }
            return Row(children: <Widget>[
              SeekBar(
                duration: duration,
                position: position,
                onChangeEnd: (newPosition) {
                  _player.seek(newPosition);
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${_printPosition(position: position)} / ${_printPosition(position: duration)}",
                overflow: TextOverflow.fade,
              )
            ]);

//              Stack(
//              children: <Widget>[
//                // position the seek bar and the texts under it appropriately
//                Positioned.fill(
//                  top: 0,
//                  bottom: 70,
//                  left: 15,
//                  right: 15,
//                  child: SeekBar(
//                    duration: duration,
//                    position: position,
//                    onChangeEnd: (newPosition) {
//                      _player.seek(newPosition);
//                    },
//                  ),
//                ),
//                Positioned(
//                  top: 27,
//                  child: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(left: customScreenWidth * 5),
//                        child: Text(_printPosition(position: position)),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(left: customScreenWidth * 50),
//                        child: Text("- " +
//                            _printPosition(position: duration - position)),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            );
          },
        );
      },
    );
  }

  Widget reloadPlayer(AudioPlaybackState state) {
    setState(() {
      state = AudioPlaybackState.playing;
    });
    return CircularProgressIndicator();
  }

  //TODO: FIX playing buttons bug when the slider is dragged back after audio playing is completed
  // controller for playing and pausing the audio
  Widget playerButtonsController() {
    return StreamBuilder<FullAudioPlaybackState>(
      stream: _player.fullPlaybackStateStream,
      builder: (context, snapshot) {
        final fullState = snapshot.data;
        var state = fullState?.state;
        final buffering = fullState?.buffering;
        if (state == AudioPlaybackState.completed && buffering == true) {
          state = AudioPlaybackState.playing;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
//            if (state == AudioPlaybackState.connecting ||
//                buffering == true)
//              Container(
//                margin: EdgeInsets.all(6.0),
//                width: 30.0,
//                height: 30.0,
//                child: CircularProgressIndicator(),
//              )

            if (state == AudioPlaybackState.playing)
              IconButton(
                icon: Icon(Icons.pause),
                iconSize: 40.0,
                onPressed: _player.pause,
              )
            else
              IconButton(
                icon: Icon(Icons.play_circle_filled),
                iconSize: 40.0,
                onPressed: _player.play,
              ),
          ],
        );
      },
    );
  }

//  counter() async {
//    int length = await databaseHelper.queryRowCount();
//    print("******");
//    print(length);
//    print("******");
//  }

  void share({String imageUrl, String audioUrl}) {
    String misbakChapeters = widget.mezmurData != null
        ? "ምስባክ፥ ${widget.mezmurData.weekMezmurList[widget.weekIndex].misbakChapters}"
        : "ምስባክ፥ ${widget.weeklyList.misbakChapters}";
    if (imageUrl != null && audioUrl == null) {
      Share.share('$misbakChapeters\n$imageUrl');
    } else if (audioUrl != null && imageUrl == null) {
      Share.share('Listen to $misbakChapeters\n$audioUrl');
    } else {
      Share.share('Check $misbakChapeters\n$imageUrl\n$audioUrl');
    }
  }

  Widget buildShareDialogActions(BuildContext context) => Column(
        children: <Widget>[
          CupertinoDialogAction(
            child: Text('Share the image'),
            onPressed: () {
              Navigator.of(context).pop();
              share(
                imageUrl: widget.mezmurData != null
                    ? widget.mezmurData.weekMezmurList[widget.weekIndex]
                        .misbakPictureRemoteUrl
                    : widget.weeklyList.misbakPictureRemoteUrl,
              );
            },
          ),
          CupertinoDialogAction(
            child: Text('Share the audio'),
            onPressed: () {
              Navigator.of(context).pop();
              share(
                audioUrl: widget.mezmurData != null
                    ? widget.mezmurData.weekMezmurList[widget.weekIndex]
                        .misbakAudioUrl
                    : widget.weeklyList.misbakAudioUrl,
              );
            },
          ),
          CupertinoDialogAction(
            child: Text('Share both'),
            onPressed: () {
              Navigator.of(context).pop();
              share(
                imageUrl: widget.mezmurData != null
                    ? widget.mezmurData.weekMezmurList[widget.weekIndex]
                        .misbakPictureRemoteUrl
                    : widget.weeklyList.misbakPictureRemoteUrl,
                audioUrl: widget.mezmurData != null
                    ? widget.mezmurData.weekMezmurList[widget.weekIndex]
                        .misbakAudioUrl
                    : widget.weeklyList.misbakAudioUrl,
              );
            },
          ),
          Divider(
            color: Colors.black,
          ),
          CupertinoDialogAction(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

  Future<void> shareDialog(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          'Sharing is Caring!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[buildShareDialogActions(context)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // variables for getting custom screen height and width
    var customScreenWidth = MediaQuery.of(context).size.width / 100;
    var customScreenHeight = MediaQuery.of(context).size.height / 100;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.mezmurData != null
                ? widget.mezmurData.weekMezmurList[widget.weekIndex].mezmurName
                : widget.weeklyList.mezmurName,
            overflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.share),
              onPressed: () {
                shareDialog(context);
              },
              iconSize: 35.0,
              color: Colors.black,
            ),
            // favorites icon button
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
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Container(
                //color: Colors.red,
                height: customScreenHeight * 60,
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
                  child: Image.asset(
                    widget.mezmurData != null
                        ? widget.mezmurData.weekMezmurList[widget.weekIndex]
                            .misbakPicturelocalPath
                        : widget.weeklyList.misbakPicturelocalPath,
                  ),
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
                        color: Colors.grey[400],
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
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        playerButtonsController(),
                        SizedBox(
                          width: 15,
                        ),
                        sliderBuilder(customScreenWidth),
                      ],
                    ),
//                    child: Stack(
//                      children: <Widget>[
//                        // seek bar and minutes and seconds text under it
//                        sliderBuilder(customScreenWidth),
//                        // play and pause controller
//                        Positioned.fill(
//                          top: 40,
//                          child: playerButtonsController(),
//                        ),
//                      ],
//                    ),
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

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    // customizes the slider
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[400],
          // the circular thumb on the slider
          thumbColor: Colors.grey[600],
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
          // the halo effect when the thumb is clicked
          overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0)),
      child: Slider(
        min: 0.0,
        max: widget.duration.inMilliseconds.toDouble(),
        value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _dragValue = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged(Duration(milliseconds: value.round()));
          }
        },
        onChangeEnd: (value) {
          _dragValue = null;
          if (widget.onChangeEnd != null) {
            widget.onChangeEnd(Duration(milliseconds: value.round()));
          }
        },
      ),
    );
  }
}
