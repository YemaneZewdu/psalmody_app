import 'package:flutter/material.dart';
import 'package:psalmody/model/mezmur.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState(mezmurData);
  final Mezmur mezmurData;

  AudioPlayerScreen(
      {Key key, @required this.mezmurData})
      : super(key: key);


}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
 final Mezmur mezmurData;
  bool isPressed = false;
 _AudioPlayerScreenState(this.mezmurData);

  void _iconPressed(){
    bool newVal = true;
    if(isPressed) {
      newVal = false;
    } else {
      newVal = true;
    }
    setState(() {
      isPressed = newVal;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(mezmurData.mezmurName),
        actions: <Widget>[
          IconButton (
            icon: Icon(isPressed ? Icons.star:Icons.star_border),
            onPressed: () => _iconPressed(),
            iconSize: 35.0,
            color: Colors.black,
          ),
        ],
      ),

    );
  }
}
