import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/view/audio_player_screen.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

class MonthMezmurListScreen extends StatelessWidget {
  final String monthName;
  Mezmur mezmurData;
  final int monthIndex;
  final SlidableController slidableController = SlidableController();

  MonthMezmurListScreen({
    Key key,
    this.monthName,
    this.mezmurData,
    this.monthIndex,
  }) : super(key: key);

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

// mezmur description might be empty so to avoid an empty line
  // in the card, check if it is ""
  Widget mezmurNameDescription(snapshot, index) => Text(
        snapshot.data.weekMezmurList[index].mezmurDescription != ""
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
            // check if not null, else return mezmur name only
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

  // lets users share or copy to clipboard
  void share(WeekMezmurList list) {
    //TODO: Enter the app store link of the app in the subject field
    Share.share(
      monthName +
          "\n" +
          list.mezmurDescription +
          "\n" +
          list.mezmurName +
          "\n" +
          "ምስባክ፥ " +
          list.misbakChapters +
          "\n" +
          list.misbakLine1 +
          "\n" +
          list.misbakLine2 +
          "\n" +
          list.misbakLine3,
    );
  }

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
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              itemCount: mezmurData.weekMezmurList.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPlayerScreen(
                          mezmurData: mezmurData,
                          weekIndex: index,
                          monthIndex: monthIndex,
                        ),
                      ),
                    ),
                  child: Slidable(
                    key:
                        new Key(snapshot.data.weekMezmurList[index].mezmurName),
                    actionPane: SlidableDrawerActionPane(),
                    controller: slidableController,
                    actionExtentRatio: 0.30,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Share',
                        color: Colors.indigo,
                        icon: Icons.share,
                        onTap: () => share(snapshot.data.weekMezmurList[index]),
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
                            mezmurNameDescription(snapshot, index),
                            SizedBox(height: 5.0),
                            Divider(
                              color: Colors.black,
                            ),
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
            child: Text(
              "Loading $monthName list...",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(monthName),
        ),
        backgroundColor: Colors.grey[300],
        body: futureWidget(context),
      ),
    );
  }
}
