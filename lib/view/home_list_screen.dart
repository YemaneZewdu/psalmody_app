import 'package:flutter/material.dart';
import 'package:psalmody/view/month_mezmur_list_screen.dart';

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
      backgroundColor: Colors.grey[400],
      body: new ListView.builder(
        itemCount: _months.length,
        itemBuilder: (BuildContext context, int index) {

          return new GestureDetector(
            onTap: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MonthMezmurListScreen(
                  monthName: _months[index],
                  monthIndex: index,
                ),
              ),
            );},
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

