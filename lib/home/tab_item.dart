import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// represents the four bottom nav tabs
enum TabItem { Home, Books, Favorites, More }

class TabItemData {
  const TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  // defining a tab item data for each of the TabItem on the bottom nav
  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.Home: TabItemData(title: 'Home', icon: Icons.home),
    TabItem.Books: TabItemData(title: 'Books', icon: CupertinoIcons.book_solid),
    TabItem.Favorites: TabItemData(title: 'Favorites', icon: Icons.star),
    TabItem.More: TabItemData(title: 'More', icon: Icons.more_horiz),
  };
}
