import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

class BooksListScreen extends StatelessWidget {
  // controls the slidable
  final SlidableController slidableController = SlidableController();
  final _books = [
    {
      'title': 'የሰንበት ቅዳሴ ማውጫ',
      'localPath': 'MezmurGitsawe.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%88%98%E1%8B%9D%E1%88%99%E1%88%AD.pdf?alt=media&token=4384342e-add8-466c-bf81-ca3138e3b96e'
    },
    {
      'title': 'መስከረም - ኅዳር ግጻዌ',
      'localPath': 'Meskerem_HidarGitsawe.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%88%98%E1%88%B5%E1%8A%A8%E1%88%A8%E1%88%9D%20_%20%E1%88%85%E1%8B%B3%E1%88%AD.pdf?alt=media&token=c3dadbc3-7460-4179-a98b-6f87992d3d5d'
    },
    {
      'title': 'ታኅሣሥ - የካቲት ግጻዌ',
      'localPath': 'Tahisas_Yekatit.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%89%B3%E1%88%85%E1%88%B3%E1%88%B5%20_%20%E1%8B%A8%E1%8A%AB%E1%89%B2%E1%89%B5.pdf?alt=media&token=4a550fdc-0570-4cd9-8f7e-f614c47c85d4'
    },
    {
      'title': 'መጋቢት  - ግንቦት ግጻዌ',
      'localPath': 'Megabit_GinbotGitsawe.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%88%98%E1%8C%8B%E1%89%A2%E1%89%B5_%20%E1%8C%8D%E1%8A%95%E1%89%A6%E1%89%B5.pdf?alt=media&token=cb0989ec-e52f-420b-858b-bf1c851bbd8b'
    },
    {
      'title': 'ሰኔ - ጳጉሜን ግጻዌ',
      'localPath': 'Sene_PuagmeGitsawe.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%88%B0%E1%8A%94%20-%20%E1%8C%B7%E1%8C%8D%E1%88%9C.pdf?alt=media&token=ad31c90e-3dab-4187-a436-f443d4b48ac0'
    },
    {
      'title': 'በተውሳክ ለሚወጡ ለሚወርዱ በዓላትና አጽዋማት ቅዳሴ ማውጫ',
      'localPath': 'TewsakGitsawe.pdf',
      'remoteUrl':
          'https://firebasestorage.googleapis.com/v0/b/psalmody-flutter.appspot.com/o/PDF%20Books%2F%E1%89%B0%E1%8B%8D%E1%88%B3%E1%8A%AD.pdf?alt=media&token=0f3182dc-c8ca-473a-a563-a770e9cd426a'
    }
  ];

  static Future<File> getAssetByName(String sourceName) async {
    var sampleData = await rootBundle.load("assets/PDFs/$sourceName");
    final path = await _localPath;
    var file = File('$path/$sourceName');
    file = await file.writeAsBytes(sampleData.buffer.asUint8List());
    return file;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // share the specific book name and remote url
  void share(String bookName, String bookUrl) {
    Share.share("$bookName \n $bookUrl", subject: bookName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Books"),
        ),
        backgroundColor: Colors.grey[300],
        body: new ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          itemCount: _books.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                var file = await getAssetByName(_books[index]['localPath']);
                // opens the pdf with the default phone app
                OpenFile.open(file.path, type: "application/pdf");
              },
              child: Slidable(
                key: new Key(_books[index]['title']),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                // closes other active slidable if there is any
                controller: slidableController,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Share',
                    color: Colors.indigo,
                    icon: CupertinoIcons.share,
                    onTap: () =>
                        share(_books[index]['title'], _books[index]['remoteUrl']),
                  ),
                ],
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 15.0,
                    ),
                    child: Text(
                      _books[index]['title'],
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
