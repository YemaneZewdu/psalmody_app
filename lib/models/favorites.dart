class Favorites {
  int weekIndex;
  String mezmurName;
  String misbakChapters;
  String misbakLine1;
  String misbakLine2;
  String misbakLine3;
  String misbakPictureUrl;
  String misbakAudioUrl;

  Favorites({
    this.weekIndex,
    this.mezmurName,
    this.misbakChapters,
    this.misbakLine1,
    this.misbakLine2,
    this.misbakLine3,
    this.misbakPictureUrl,
    this.misbakAudioUrl,
  });

  @override
  String toString() =>
      "misbakChapters : $misbakChapters, mezmurName: $mezmurName, weekIndex: $weekIndex, "
      "misbakLine1: $misbakLine1, misbakLine2: $misbakLine2, misbakLine3: $misbakLine3,"
      "misbakPictureUrl: $misbakPictureUrl, misbakAudioUrl: $misbakAudioUrl";

  // changes Favorites object to map
  Map<String, dynamic> toMap() {
    // used for assigning the incoming values
    var map = <String, dynamic>{
      'misbakChapters': misbakChapters,
      "mezmurName": mezmurName,
      "weekIndex": weekIndex,
      "misbakLine1": misbakLine1,
      "misbakLine2": misbakLine2,
      "misbakLine3": misbakLine3,
      "misbakPictureUrl": misbakPictureUrl,
      "misbakAudioUrl": misbakAudioUrl
    };
    return map;
  }

  // extract the Id and the data from the map
  Favorites.fromMap(Map<String, dynamic> map) {
    misbakChapters = map["misbakChapters"];
    mezmurName = map["mezmurName"];
    weekIndex = map["weekIndex"];
    misbakLine1 = map["misbakLine1"];
    misbakLine2 = map["misbakLine2"];
    misbakLine3 = map["misbakLine3"];
    misbakPictureUrl = map["misbakPictureUrl"];
    misbakAudioUrl = map["misbakAudioUrl"];
  }
}
