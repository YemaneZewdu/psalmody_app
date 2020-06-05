import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalmody/home/tab_item.dart';

// shows the bottom nav
// this class creates a CupertinoHomeScaffold that knows what tabs to present
class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys
  }) : super(key: key);

  final TabItem currentTab;

  // notifies the home page when the user selects a tab
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // creating the items in the tab bar
        items: [
          _buildItem(TabItem.Home),
          _buildItem(TabItem.Books),
          _buildItem(TabItem.Favorites),
          _buildItem(TabItem.More),
        ],
        // referencing the enum with index
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      // shows the content of each tab
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  // returns a bottom nav bar
  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    // checking if the tab is currently selected to give it a color
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }
}
