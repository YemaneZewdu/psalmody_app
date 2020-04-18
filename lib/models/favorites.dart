class Favorites {
  //int id;
  String misbakChapters;
  String mezmurName;
  int weekIndex;
  String misbakLine1;
  String misbakLine2;
  String misbakLine3;

  Favorites({
    //this.id,
    this.misbakChapters,
    this.mezmurName,
    this.weekIndex,
    this.misbakLine1,
    this.misbakLine2,
    this.misbakLine3,
  });

  @override
  String toString() =>
      "misbakChapters : $misbakChapters, mezmurName: $mezmurName, weekIndex: $weekIndex, "
          "misbakLine1: $misbakLine1, misbakLine2: $misbakLine2, misbakLine3: $misbakLine3";


  // changes Favorites object to map
  Map<String, dynamic> toMap() {
    // used for assigning the incoming values
    var map = <String, dynamic>{
      //'id': id,
      'misbakChapters': misbakChapters,
      "mezmurName": mezmurName,
      "weekIndex": weekIndex,
      "misbakLine1": misbakLine1,
      "misbakLine2": misbakLine2,
      "misbakLine3": misbakLine3
    };
    return map;
  }

  // extract the Id and the data from the map
  Favorites.fromMap(Map<String, dynamic> map) {
    // id = map["id"];
    misbakChapters = map["misbakChapters"];
    mezmurName = map["mezmurName"];
    weekIndex = map["weekIndex"];
    misbakLine1 = map["misbakLine1"];
    misbakLine2 = map["misbakLine2"];
    misbakLine3 = map["misbakLine3"];
  }
}
