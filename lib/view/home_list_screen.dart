import 'package:flutter/material.dart';
import 'package:psalmody/view/month_mezmur_list_screen.dart';
import 'package:psalmody/models/mezmur.dart';

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
      backgroundColor: Color(0xffEBEFF2),
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

Mezmur getFakeData() {
  Mezmur obj = Mezmur();
//  obj.mezmurNumber = 1;
//  obj.mezmurName = 'Mezmur Name';
//  obj.mezmurDescription = 'Mezmur Description';
//  obj.misbakChapter = 5;
//  obj.misbakNumber1 = 6;
//  obj.misbakNumber2 = '9:11';
//  obj.misbakLine1 = 'Misbak line 1';
//  obj.misbakLine2 = 'Misbak line 2';
//  obj.misbakLine3='Misbak line 3';
//  obj.misbakPictureUrl =  "https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjC_IGdq6zlAhWEiOAKHSWWChAQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.nashvillepublicradio.org%2Fpost%2Fafter-years-division-nashville-s-ethiopian-churches-gather-mark-reconciliation&psig=AOvVaw25lto_-NkZ_uxqM75qZ6Kz&ust=1571712398796114";
//  //"https://drive.google.com/open?id=1bvHAMhbS4Rns9h-9X6HvKHyh_xMXKgFl";
  return obj;
}
