class WeekMezmurList {
   int? weekId;
   String? mezmurName;
   String? mezmurDescription;
   String? misbakChapters;
   String? misbakLine1;
   String? misbakLine2;
   String? misbakLine3;
   String? misbakPictureRemoteUrl;
   String? misbakPicturelocalPath;
   String? misbakAudioUrl;

  WeekMezmurList({
     this.weekId,
     this.mezmurName,
     this.mezmurDescription,
     this.misbakChapters,
     this.misbakLine1,
     this.misbakLine2,
     this.misbakLine3,
     this.misbakPictureRemoteUrl,
     this.misbakPicturelocalPath,
     this.misbakAudioUrl,
  });

  // Serializing the JSON
  factory WeekMezmurList.fromJson(Map<String?, dynamic> parsedJson) =>
      WeekMezmurList(
        weekId: parsedJson["weekId"],
        mezmurName: parsedJson["mezmurName"],
        mezmurDescription: parsedJson["mezmurDescription"],
        misbakChapters: parsedJson["misbakChapters"],
        misbakLine1: parsedJson["misbakLine1"],
        misbakLine2: parsedJson["misbakLine2"],
        misbakLine3: parsedJson["misbakLine3"],
        misbakPictureRemoteUrl: parsedJson["misbakPictureRemoteUrl"],
        misbakPicturelocalPath: parsedJson["misbakPicturelocalPath"],
        misbakAudioUrl: parsedJson["misbakAudioUrl"],
      );



  @override
  String toString() =>
      "weekId: $weekId, mezmurName: $mezmurName, mezmurDescription: $mezmurDescription, "
      "misbakChapters: $misbakChapters, misbakLine1: $misbakLine1, misbakLine2: $misbakLine2,"
      "misbakLine3: $misbakLine3, misbakPictureRemoteUrl: $misbakPictureRemoteUrl,"
      "misbakPicturelocalPath: $misbakPicturelocalPath, misbakAudioUrl: $misbakAudioUrl";

// changes to JSON, not used in the project
  Map<String?, dynamic> toJson() => {
        "weekId": weekId,
        "mezmurName": mezmurName,
        "mezmurDescription": mezmurDescription,
        "misbakChapters": misbakChapters,
        "misbakLine1": misbakLine1,
        "misbakLine2": misbakLine2,
        "misbakLine3": misbakLine3,
        "misbakPictureRemoteUrl": misbakPictureRemoteUrl,
        "misbakPicturelocalPath": misbakPicturelocalPath,
        "misbakAudioUrl": misbakAudioUrl,
      };

  // changes Favorites object to map
  Map<String, Object?> toMap() {
    // used for assigning the incoming values
    var map = <String, Object?>{
      "weekId": weekId,
      "mezmurName": mezmurName,
      "misbakChapters": misbakChapters,
      "misbakLine1": misbakLine1,
      "misbakLine2": misbakLine2,
      "misbakLine3": misbakLine3,
      "misbakPictureRemoteUrl": misbakPictureRemoteUrl,
      "misbakPicturelocalPath": misbakPicturelocalPath,
      "misbakAudioUrl": misbakAudioUrl,
    };
    return map;
  }
  // extract the Id and the data from the map
  WeekMezmurList.fromMap(Map<dynamic, dynamic> map) {
    weekId = map["weekId"];
    mezmurName = map["mezmurName"];
    misbakChapters = map["misbakChapters"];
    misbakLine1 = map["misbakLine1"];
    misbakLine2 = map["misbakLine2"];
    misbakLine3 = map["misbakLine3"];
    misbakPictureRemoteUrl = map["misbakPictureRemoteUrl"];
    misbakPicturelocalPath = map["misbakPicturelocalPath"];
    misbakAudioUrl = map["misbakAudioUrl"];
  }

}
