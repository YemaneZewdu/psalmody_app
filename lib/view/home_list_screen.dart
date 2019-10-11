import 'package:flutter/material.dart';
import 'package:psalmody/view/month_mezmur_list_screen.dart';
import 'package:psalmody/model/mezmur.dart';

class HomeListScreen extends StatelessWidget {
  final _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        itemCount: _months.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    MonthMezmurListScreen(monthName:_months[index], mezmurData: getFakeData())),),
            child: new Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
Mezmur getFakeData() {
  Mezmur obj = Mezmur();
  obj.mezmurNumber = 1;
  obj.mezmurName = 'Mezmur Name';
  obj.mezmurDescription = 'Mezmur Description';
  obj.misbakChapter = 5;
  obj.misbakNumber1 = 6;
  obj.misbakNumber2 = '9:11';
  obj.misbakLine1 = 'Misbak line 1';
  obj.misbakLine2 = 'Misbak line 2';
  obj.misbakLine3='Misbak line 3';

  return obj;
}
