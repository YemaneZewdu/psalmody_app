import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/model/mezmur.dart';

class MonthMezmurListScreen extends StatelessWidget {
  final String monthName;
  Mezmur mezmurData;

  MonthMezmurListScreen(
      {Key key, @required this.monthName, @required this.mezmurData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text(monthName),
        ),
        body: new ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: () => print("Clicked"),
              child: new Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 15.0),
                      child: Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  mezmurData.mezmurName,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  mezmurData.mezmurDescription,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Chapter: ${mezmurData.misbakChapter} - ' +
                                      mezmurData.misbakNumber2,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  mezmurData.misbakLine1,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  mezmurData.misbakLine2,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  mezmurData.misbakLine3,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            );
          },
        ));
  }
}
