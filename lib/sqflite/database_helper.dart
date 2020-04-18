import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psalmody/models/favorites.dart';

class DatabaseHelper {
  // column names and a db name
  static Database _database;

  // static const String ID = 'id';
  static const String TABLE = 'Favotires';
  static const String DB_NAME = 'favorites.db';
  static const String MEZMUR_NAME = 'mezmurName';
  static const String WEEK_INDEX = 'weekIndex';
  static const String MISBAK_CHAPTERS = 'misbakChapters';
  static const String MISBAK_LINE1 = 'misbakLine1';
  static const String MISBAK_LINE2 = 'misbakLine2';
  static const String MISBAK_LINE3 = 'misbakLine3';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // get the database
  Future<Database> get getDb async {
    if (_database != null) {
      return _database;
    }
    // else create a new one
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // creating the directory for the db
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // get the directory path
    String path = join(documentsDirectory.path, DB_NAME);
    // opening the db with the path
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // create the db
  Future _onCreate(Database db, int version) async {
    //$ID INTGER NOT NULL,
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE ($MEZMUR_NAME TEXT PRIMARY KEY, $WEEK_INDEX INTEGER, $MISBAK_CHAPTERS TEXT, $MISBAK_LINE1 TEXT, $MISBAK_LINE2 TEXT, $MISBAK_LINE3 TEXT)''');
  }

  // insert to the db
  Future<int> insertToDb(Favorites favorites) async {
    // get the db
    var dbClient = await getDb;
    try {
      // convert to a map and insert to db
      // favorites.favoriteId = await dbClient.insert(TABLE, favorites.toMap());

      // using the raw sql query
      /*await dbClient.transaction((txn) async {
      // using quotations because favoritesData is a string
      var query = "INSERT INTO $TABLE ($FAVORITES) VALUES ('" + favorites.favoritesData + "')";
      return await txn.rawInsert(query);
    });*/

      return await dbClient.insert(TABLE, favorites.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("DatabaseHelper Insert method" + e.toString());
    }
  }

  Future<List<Favorites>> getFavorites() async {
    // get the db
    var dbClient = await getDb;
    //getting the column data
    List<Map> maps = await dbClient.query(TABLE, columns: [
      MEZMUR_NAME,
      WEEK_INDEX,
      MISBAK_CHAPTERS,
      MISBAK_LINE1,
      MISBAK_LINE2,
      MISBAK_LINE3
    ]);
    // raw query
    //  List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Favorites> favoriteList = [];
    if (maps.length > 0) {
      // if true, the map has at least one value
      for (int i = 0; i < maps.length; i++) {
        favoriteList.add(Favorites.fromMap(maps[i]));
      }
      return favoriteList;
    }
    return null;

  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await getDb;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $TABLE'));
  }

  // deleting a value from the db
  Future<int> delete({String mezmurName}) async {
    var dbClient = await getDb;
    try {
      return await dbClient
          .delete(TABLE, where: '$MEZMUR_NAME = ?', whereArgs: [mezmurName]);
    } catch (e) {
      print("DatabaseHelper Delete method" + e.toString());
    }
  }

  // check if in favorites
  Future<bool> inFavorites({String mezmurName}) async {
    var dbClient = await getDb;
    try {
      List<Map> maps = await dbClient
          .query(TABLE, where: '$MEZMUR_NAME = ?', whereArgs: [mezmurName]);
      return maps.length == 1 ? true : false;
    } catch (e) {
      print("DatabaseHelper Infavorites" + e.toString());
    }
    return false;
  }
//Future drop () async {
//    var db = await getDb;
//    db.execute("DROP TABLE IF EXISTS $TABLE");
//}
  // close the db
  Future closeDb() async {
    var dbClient = await getDb;
    dbClient.close();
  }
}
