import 'package:psalmody/models/week_mezmur_list.dart';
class Mezmur {
  final String month;
  final List<WeekMezmurList> weekMezmurList;

  Mezmur({
    this.month,
    this.weekMezmurList,
  });

  @override
  String toString() => "month: $month, weekMezmurList: $weekMezmurList";

  // Serializing the JSON
  factory Mezmur.fromJson(List<dynamic> parsedJson, int monthIndex) {
    //solution to avoid type error:  'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'

    List<WeekMezmurList> weeklyList = new List<WeekMezmurList>();
    String monthValue = parsedJson[monthIndex]["month"];

    // going through the week list
    if (parsedJson[monthIndex]["weekMezmurList"] != null) {
      parsedJson[monthIndex]["weekMezmurList"].forEach(
        (v) {
          weeklyList.add(
            WeekMezmurList.fromJson(v),
          );
        },
      );
    }

    return Mezmur(month: monthValue, weekMezmurList: weeklyList);
  }

  // used for searching
  factory Mezmur.filterList(List<dynamic> parsedJson){
    List<WeekMezmurList> weeklyList = new List<WeekMezmurList>();

    for (var i=0; i<parsedJson.length; i++) {

      // going through the week list
      if (parsedJson[i]["weekMezmurList"] != null) {
        parsedJson[i]["weekMezmurList"].forEach(
              (v) {
            weeklyList.add(
              WeekMezmurList.fromJson(v),
            );
          },
        );
      }
    }
    return Mezmur(weekMezmurList: weeklyList);

  }

// convert to JSON, not used in the project
  Map<String, dynamic> toJson() => {
        "month": month,
        "weekMezmurList": List<dynamic>.from(
          weekMezmurList.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

