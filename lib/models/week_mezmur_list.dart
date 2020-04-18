class WeekMezmurList {
  final int weekId;
  final String mezmurName;
  final String mezmurDescription;
  final String firstReadingChapters;
  final String secondReadingChapters;
  final String misbakChapters;
  final String misbakLine1;
  final String misbakLine2;
  final String misbakLine3;
  final String misbakPictureUrl;
  final String misbakAudioUrl;

  WeekMezmurList({
    this.weekId,
    this.mezmurName,
    this.mezmurDescription,
    this.firstReadingChapters,
    this.secondReadingChapters,
    this.misbakChapters,
    this.misbakLine1,
    this.misbakLine2,
    this.misbakLine3,
    this.misbakPictureUrl,
    this.misbakAudioUrl,
  });

  // Serializing the JSON
  factory WeekMezmurList.fromJson(Map<String, dynamic> parsedJson) =>
      WeekMezmurList(
        weekId: parsedJson["weekId"],
        mezmurName: parsedJson["mezmurName"],
        mezmurDescription: parsedJson["mezmurDescription"],
        firstReadingChapters: parsedJson["firstReadingChapters"],
        secondReadingChapters: parsedJson["secondReadingChapters"],
        misbakChapters: parsedJson["misbakChapters"],
        misbakLine1: parsedJson["misbakLine1"],
        misbakLine2: parsedJson["misbakLine2"],
        misbakLine3: parsedJson["misbakLine3"],
        misbakPictureUrl: parsedJson["misbakPictureUrl"],
        misbakAudioUrl: parsedJson["misbakAudioUrl"],
      );

  @override
  String toString() =>
      "weekId: $weekId, mezmurName: $mezmurName, mezmurDescription: $mezmurDescription, "
          "firstReadingChapters: $firstReadingChapters, secondReadingChapters: $secondReadingChapters, misbakChapters: $misbakChapters,"
          "misbakLine1: $misbakLine1, misbakLine2: $misbakLine2, misbakLine3: $misbakLine3,"
          "misbakPictureUrl: $misbakPictureUrl, misbakAudioUrl: $misbakAudioUrl";

// change to JSON, not used in the project
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "mezmurName": mezmurName,
    "mezmurDescription": mezmurDescription,
    "firstReadingChapters": firstReadingChapters,
    "secondReadingChapters": secondReadingChapters,
    "misbakChapters": misbakChapters,
    "misbakLine1": misbakLine1,
    "misbakLine2": misbakLine2,
    "misbakLine3": misbakLine3,
    "misbakPictureUrl": misbakPictureUrl,
    "misbakAudioUrl": misbakAudioUrl,
  };

//  // changes Favorites object to map
//  Map<String, dynamic> toMap() {
//    // used for assigning the incoming values
//    var map = <String, dynamic>{
//
//      'misbakChapters': misbakChapters,
//      "mezmurName": mezmurName,
//      "weekId": weekId,
//      "misbakLine1": misbakLine1,
//      "misbakLine2": misbakLine2,
//      "misbakLine3": misbakLine3,
//      "misbakPictureUrl": misbakPictureUrl,
//      "misbakAudioUrl": misbakAudioUrl,
//
//    };
//    return map;
//  }
//
//  // extract the Id and the data from the map
//  WeekMezmurList.fromMap(Map<String, dynamic> map, this.weekId, this.mezmurName, this.mezmurDescription, this.firstReadingChapters, this.secondReadingChapters, this.misbakChapters, this.misbakLine1, this.misbakLine2, this.misbakLine3, this.misbakPictureUrl, this.misbakAudioUrl) {
//    // id = map["id"];
//    misbakChapters = map["misbakChapters"];
//    mezmurName = map["mezmurName"];
//    weekIndex = map["weekIndex"];
//    misbakLine1 = map["misbakLine1"];
//    misbakLine2 = map["misbakLine2"];
//    misbakLine3 = map["misbakLine3"];
//  }
}
