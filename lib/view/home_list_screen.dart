import 'package:flutter/material.dart';
import 'package:psalmody/view/month_mezmur_list_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
                MaterialPageRoute(
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
    );
  }
}
