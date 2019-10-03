import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState ();
  }

}

class HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Psalmody MVP"),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text( ),
          ] ,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}