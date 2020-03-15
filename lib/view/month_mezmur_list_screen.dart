import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/view/audio_player_screen.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


class MonthMezmurListScreen extends StatelessWidget {
  final String monthName;
  Mezmur mezmurData;
  final int monthIndex;

  MonthMezmurListScreen(
      {Key key,
      @required this.monthName,
      this.mezmurData,
      @required this.monthIndex})
      : super(key: key);

  //load JSON
  Future<String> loadJson() async {
    return await rootBundle.loadString('assets/mezmurs.json');
  }

  // load mezmur by the given month index
  Future<Mezmur> loadMezmur({int monthIndex}) async {
    String jsonString = await loadJson();
    final jsonResponse = json.decode(jsonString);
    mezmurData = new Mezmur.fromJson(jsonResponse, monthIndex);

    return mezmurData;
  }

  Widget mezmurNameDescription(snapshot, index) => Text(
        snapshot.data.weekMezmurList[index].mezmurDescription != null
            ? snapshot.data.weekMezmurList[index].mezmurDescription +
                "\n" +
                snapshot.data.weekMezmurList[index].mezmurName
            : snapshot.data.weekMezmurList[index].mezmurName,
        textAlign: TextAlign.center,
      );

  Widget misbakLines(snapshot, index) => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //  SizedBox(height: 5.0),
            // check if not null, else return only mezmur name only
            Text(
              snapshot.data.weekMezmurList[index].misbakLine1 +
                  "\n" +
                  snapshot.data.weekMezmurList[index].misbakLine2 +
                  "\n" +
                  snapshot.data.weekMezmurList[index].misbakLine3,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      );

  Widget misbakChapter(snapshot, index) => Column(
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
              Text(snapshot.data.weekMezmurList[index].misbakChapters),
            ],
          )
        ],
      );

  // custom future widget returning list view
  Widget futureWidget(BuildContext context) {
    return new FutureBuilder<Mezmur>(
      future: loadMezmur(monthIndex: monthIndex),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
//            for(var i = 0; i < mezmurData.weekMezmurList.length; i++) {
//              print("****" + mezmurData.toString() + "\n");
//              print(mezmurData.month + "\n");
//             print(mezmurData.weekMezmurList);
//            }
            return ListView.builder(
              itemCount: mezmurData.weekMezmurList.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                          imageLink: snapshot
                              .data.weekMezmurList[index].misbakPictureUrl,
                          audioLink: snapshot
                              .data.weekMezmurList[index].misbakAudioUrl,
                          mezmurName:
                              snapshot.data.weekMezmurList[index].mezmurName),
                    ),
                  ),
                  child: new Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            mezmurNameDescription(snapshot, index),
                            SizedBox(height: 5.0),
                            Row(
                              children: <Widget>[
                                misbakChapter(snapshot, index),
                                SizedBox(width: 15),
                                misbakLines(snapshot, index),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          print("Error!!" + snapshot.error.toString());
          return Container(
            child: Center(
              child: Text("Please try again!"),
            ),
          );
        }
        return Container(
          child: Center(
            child: Text("Loading..."),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(monthName),
      ),
      backgroundColor: Colors.grey[400],
      body: futureWidget(context),
    );
  }
}
