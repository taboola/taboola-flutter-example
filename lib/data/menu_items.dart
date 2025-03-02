import 'dart:ui';

import 'package:taboola_flutter_example/constants/colors.dart';
import 'package:taboola_flutter_example/models/menu_item_model.dart';

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
          title: 'Web Integration Page',
          itemColor: Color.fromARGB(255, 240, 147, 67),
          routeName: '/webIntegration',
        ),
        MenuItemModel(
          title: 'Web Integration InappWebview Page',
          itemColor: Color.fromARGB(255, 240, 67, 149),
          routeName: '/webIntegrationInappWebview',
        ),
      ];
}
