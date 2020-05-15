class WeekMezmurList {
  final int weekId;
  final String mezmurName;
  final String mezmurDescription;
  final String misbakChapters;
  final String misbakLine1;
  final String misbakLine2;
  final String misbakLine3;
  final String misbakPictureRemoteUrl;
  final String misbakPicturelocalPath;
  final String misbakAudioUrl;

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
  factory WeekMezmurList.fromJson(Map<String, dynamic> parsedJson) =>
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
  Map<String, dynamic> toJson() => {
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
}
