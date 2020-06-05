import 'package:flutter/material.dart';
import 'package:psalmody/home/cupertino_home_scaffold.dart';
import 'package:psalmody/home/tab_item.dart';
import 'package:psalmody/view/books_list_screen.dart';
import 'package:psalmody/view/favorites_list_screen.dart';
import 'package:psalmody/view/home_list_screen.dart';
import 'package:psalmody/view/more_list_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// keeps track of the current tab
class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Home;

  // used for willScopePop used for accessing the navigator state of each tab
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Home: GlobalKey<NavigatorState>(),
    TabItem.Books: GlobalKey<NavigatorState>(),
    TabItem.Favorites: GlobalKey<NavigatorState>(),
    TabItem.More: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.Home: (_) => HomeListScreen(),
      TabItem.Books: (_) => BooksListScreen(),
      TabItem.Favorites: (_) => FavoritesListScreen(),
      TabItem.More: (_) => MoreListScreen(),
    };
  }

  // updates the current tab variable
  void _select(TabItem tabItem) {
    // this enables to tap on the current active bottomNav tab to get back to
    // the starting page
    if (tabItem == _currentTab) {
      //pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //WillPopScope is useful when using multiple navigations
      // onWillPop is called every time we press the back button on android
      // maybePop will pop and return true only when there is more than one
      // route in the navigation stack, if not it will return false,
      // therefore we negated it with '!' so that the user can exit the app
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
