import 'dart:async';

import 'package:psalmody/models/week_mezmur_list.dart';
import 'package:psalmody/sqflite/database_helper.dart';

class FavoritesBloc{
  FavoritesBloc(){
    getFavorites();
  }

  final databaseHelper = DatabaseHelper.instance;
  // broadcast makes it to start listening to events
  final _controller = StreamController<List<WeekMezmurList>>.broadcast();
  get favStream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  getFavorites () async{
    _controller.sink.add(await databaseHelper.getFavorites());
  }

  insert(WeekMezmurList fav){
    databaseHelper.insertToDb(fav);
    getFavorites();
  }

  delete(String mezmurName) async{
    await databaseHelper.delete(mezmurName: mezmurName);
    getFavorites();
  }
}