import 'dart:ui';

import '../constants/colors.dart';
import '../models/menu_item_model.dart';

class MenuItemRepository {
  static List<MenuItemModel> getMenuItems() => const [
        MenuItemModel(
          title: 'SliverList Widget + Feed',
          itemColor: Color.fromRGBO(181, 230, 235, 1),
          routeName: '/customscrollviewfeedAndWidget',
        ),
        MenuItemModel(
          title: 'SliverGrid Widget',
          itemColor: AppColors.green,
          routeName: '/customscrollviewWidget',
        ),
        MenuItemModel(
          title: 'ListView Widget',
          itemColor: Color.fromARGB(255, 67, 240, 177),
          routeName: '/customlistviewfeedAndWidget',
        ),
        MenuItemModel(
          title: 'Feed With Web View',
          itemColor: Color.fromARGB(255, 106, 116, 228),
          routeName: '/CustomScrollViewWebViewFeed',
        ),
        MenuItemModel(
          title: 'Future List Widget',
          itemColor: Color.fromARGB(255, 190, 116, 228),
          routeName: '/CustomFutureListViewPageWidget',
        ),
        
      ];
}
