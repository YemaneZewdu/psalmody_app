import 'package:flutter/material.dart';
import '../view/home_list_screen.dart';
import '../view/books_list_screen.dart';
import '../view/favorites_list_screen.dart';
import '../view/more_list_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  static const _duration = const Duration(milliseconds: 10);
  static const _curve = Curves.ease;
  int _selectedPageIndex = 0;
  PageController _pageController = PageController();

  void _onPageSelected(int index) {
   // _pageController.animateToPage(index, duration: _duration, curve: _curve);
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  void pageChanged(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  final List<Widget> _pages = <Widget>[
    HomeListScreen(),
    BooksListScreen(),
    FavoritesListScreen(),
    MoreListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedPageIndex],

//        Container(
//          child: PageView.builder(
//            onPageChanged: (index) {
//              pageChanged(index);
//            },
//            itemBuilder: (BuildContext context, int index) {
//              return _pages[index];
//            },
//            itemCount: _pages.length,
//            controller: _pageController,
//          ),
//        ),

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.indigo,
          backgroundColor: Colors.grey[200],
          onTap: _onPageSelected,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPageIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text("Books"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border),
              title: Text("Favorite"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text("More"),
            ),
          ],
        ),
      ),
    );
  }
}
