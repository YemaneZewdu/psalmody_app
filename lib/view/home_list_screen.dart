import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:psalmody/models/mezmur.dart';
import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/view/month_mezmur_list_screen.dart';
import 'package:share/share.dart';

import 'audio_player_screen.dart';
import 'favorites_bloc.dart';

class HomeListScreen extends StatelessWidget {
  final _months = [
    "መስከረም",
    "ጥቅምት",
    "ኅዳር",
    "ታኅሣሥ",
    "ጥር",
    "የካቲት",
    "ዐቢይ ጾም",
    "ትንሣኤ",
    "ክረምት"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // calls the search class
                showSearch(context: context, delegate: Search());
              },
            )
          ],
        ),
        backgroundColor: Colors.grey[300],
        body: new ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          itemCount: _months.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MonthMezmurListScreen(
                      monthName: _months[index],
                      monthIndex: index,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    // text padding
                    vertical: 20.0,
                    horizontal: 10.0,
                  ),
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Search extends SearchDelegate<WeekMezmurList> {
  Mezmur mezmur;
  final SlidableController slidableController = SlidableController();

  // search field label
  @override
  String get searchFieldLabel => 'Search here';

  //load JSON
  Future<String> loadJson() async {
    return await rootBundle.loadString('assets/mezmurs.json');
  }

  // load mezmur by the given month index
  Future<Mezmur> loadMezmur() async {
    String jsonString = await loadJson();
    final jsonResponse = json.decode(jsonString);
    mezmur = new Mezmur.filterList(jsonResponse);

    return mezmur;
  }

  // clear search icon
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  // back icon
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.left_chevron,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // changes the default white text field on the search bar
//  @override
//  ThemeData appBarTheme(BuildContext context) {
//    assert(context != null);
//    final ThemeData theme = Theme.of(context);
//    assert(theme != null);
//    return theme;
//  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // mezmur description might be empty so to avoid an empty line
  // in the card, check if it is ""
  Widget mezmurNameDescription(List<WeekMezmurList> results, index) => Text(
        results[index].mezmurDescription != ""
            ? results[index].mezmurDescription +
                "\n" +
                results[index].mezmurName
            : results[index].mezmurName,
        textAlign: TextAlign.center,
      );

  Widget misbakLines(List<WeekMezmurList> results, index) => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // check if not null, else return mezmur name only
            Text(
              results[index].misbakLine1 +
                  "\n" +
                  results[index].misbakLine2 +
                  "\n" +
                  results[index].misbakLine3,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      );

  Widget misbakChapter(List<WeekMezmurList> results, index) => Column(
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
              Text(results[index].misbakChapters),
            ],
          )
        ],
      );

  Widget informUser(String hintText) {
    return Center(
      child: Text(
        hintText,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  // lets users share or copy to clipboard
  void share(WeekMezmurList list) {
    //TODO: Enter the app store link of the app in the subject field
    Share.share(
        "${list.mezmurDescription}\n${list.mezmurName}\nምስባክ፥ ${list.misbakChapters}\n${list.misbakLine1}"
        "\n${list.misbakLine2}\n${list.misbakLine3}");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Mezmur>(
      future: loadMezmur(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
//        if () {
//          return informUser("Error");
//        }

          if (query.isEmpty || query.length < 3) {
            return informUser("Type to search");
          }

          List<WeekMezmurList> results = new List<WeekMezmurList>();
          for (var i = 0; i < mezmur.weekMezmurList.length; i++) {
            if (((mezmur.weekMezmurList[i].mezmurName.contains(query)) ||
                    (mezmur.weekMezmurList[i].mezmurDescription
                        .contains(query)) ||
                    (mezmur.weekMezmurList[i].misbakLine1.contains(query)) ||
                    (mezmur.weekMezmurList[i].misbakLine2.contains(query)) ||
                    (mezmur.weekMezmurList[i].misbakLine3.contains(query))) &&
                query.isNotEmpty) {
              results.add(mezmur.weekMezmurList[i]);
            }
          }

//        return ListView(
//            children: results
//                .map<ListTile>((a) => ListTile(
//                      title: Text(results),
//                    ))
//                .toList());
          if (results.isEmpty) {
            return informUser("No data! Please try again!");
          }

          return SafeArea(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        weeklyList: results[index],
                        weekIndex: index,
                        favoritesBloc: FavoritesBloc(),
                      ),
                    ),
                  ),
                  child: Slidable(
                    key: new Key(results[index].mezmurName),
                    actionPane: SlidableDrawerActionPane(),
                    controller: slidableController,
                    actionExtentRatio: 0.30,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Share',
                        color: Colors.indigo,
                        icon: CupertinoIcons.share,
                        onTap: () => share(results[index]),
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
                            mezmurNameDescription(results, index),
                            SizedBox(height: 5.0),
                            Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: <Widget>[
                                misbakChapter(results, index),
                                SizedBox(width: 15),
                                misbakLines(results, index),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          informUser("Error! Please try again");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
