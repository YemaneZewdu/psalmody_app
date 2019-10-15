import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BooksListScreen extends StatelessWidget {
  final _books = [
    {'title': 'Yezewtir Gitsawe PDF', 'description': 'Yezewetir kidase mawcha', 'url': 'https://drive.google.com/file/d/14FKmgnUe7jMHcZZMsswvuXiZHP-ZEP6Y/view?usp=sharing' },
    {'title': 'Yetewsak Gitsawe PDF', 'description': 'Letewsak bealat kidase mawcha', 'url': 'https://drive.google.com/file/d/1b4i7DAVmF7ncGHL0G7Cd53cU6mtSPJjp/view?usp=sharing'},
    {'title': 'Yesenbet Gitsawe PDF', 'description': 'Yesenbet kidase mawcha', 'url': 'https://drive.google.com/file/d/1-IwFZKu3tvmoOb34HCZ8BPnnigQl3sLn/view?usp=sharing'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        itemCount: _books.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LaunchUrl(title: _books[index]['title'], url: _books[index]['url']);
                },
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      _books[index]['title'],
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 1.6,
                      ),
                    ),
                    subtitle: Text(
                      _books[index]['description'],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LaunchUrl extends StatelessWidget {
  final String title;
  final String url;

  LaunchUrl({Key key, this.title, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withLocalStorage: true,
      url: url,
      withZoom: true,
      hidden: true,
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
