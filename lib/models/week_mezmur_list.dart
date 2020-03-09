class WeekMezmurList {
  final String mezmurId;
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
    this.mezmurId,
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
        mezmurId: parsedJson["mezmurId"],
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
      "mezmurId: $mezmurId, mezmurName: $mezmurName, mezmurDescription: $mezmurDescription, "
          "firstReadingChapters: $firstReadingChapters, secondReadingChapters: $secondReadingChapters, misbakChapters: $misbakChapters,"
          "misbakLine1: $misbakLine1, misbakLine2: $misbakLine2, misbakLine3: $misbakLine3,"
          "misbakPictureUrl: $misbakPictureUrl, misbakAudioUrl: $misbakAudioUrl";

// change to JSON, not used in the project
  Map<String, dynamic> toJson() => {
    "mezmurId": mezmurId,
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
}
