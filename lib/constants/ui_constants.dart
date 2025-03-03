import 'package:flutter/material.dart';

class UIConstants {
  // Home page
  static const double logoHeight = 100.0;
  static const double menuItemExtent = 110.0;
  static const double menuItemBottomPadding = 20.0;
  static const EdgeInsets logoPadding = EdgeInsets.all(16.0);
  static const EdgeInsets menuPadding = EdgeInsets.all(20.0);
  
  // Text styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  
  // CustomScrollViewPageFeedAndWidget constants
  static const int viewId = 123;
  static const int listItemCount = 10;
  static const double listItemHeight = 50.0;
  static const double emptyWidgetHeight = 100.0;
  static const int colorModBase = 9;
  
  // CustomListViewPageFeedAndWidget constants
  static const int listLength = 10;
  static const int widgetPosition = 5;
  static const int feedPosition = 9;
  static const double widgetHeight = 300.0;
  static const double feedHeight = 1600.0;
  static const double defaultItemHeight = 200.0;
  static const int widgetViewId = 123;
  static const int feedViewId = 123333;
  
  // CustomScrollViewPageWidget constants
  static const int gridItemCount = 10;
  static const int taboolaWidgetPosition = 5;
  static const double maxCrossAxisExtent = 200.0;
  static const double mainAxisSpacing = 10.0;
  static const double crossAxisSpacing = 10.0;
  static const double childAspectRatio = 1.0;
  
  // WebIntegrationPage constants
  static const int webListLength = 20;
  static const double webContainerHeight = 670.0;
  static const double listItemPadding = 20.0;
} 