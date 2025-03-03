import 'package:taboola_flutter_example/constants/app_strings.dart';
import 'package:taboola_flutter_example/constants/colors.dart';
import 'package:taboola_flutter_example/constants/routes.dart';
import 'package:taboola_flutter_example/models/menu_item_model.dart';

class MenuItemRepository {
  static List<MenuItemModel> getMenuItems() => const [
        MenuItemModel(
          title: AppStrings.menuItemSliverListWidgetFeed,
          itemColor: AppColors.lightBlue,
          routeName: Routes.customScrollViewFeedAndWidget,
        ),
        MenuItemModel(
          title: AppStrings.menuItemSliverGridWidget,
          itemColor: AppColors.green,
          routeName: Routes.customScrollViewWidget,
        ),
        MenuItemModel(
          title: AppStrings.menuItemListViewWidget,
          itemColor: AppColors.lightGreen,
          routeName: Routes.customListViewFeedAndWidget,
        ),
        MenuItemModel(
          title: AppStrings.menuItemWebIntegration,
          itemColor: AppColors.orange,
          routeName: Routes.webIntegration,
        ),
        MenuItemModel(
          title: AppStrings.menuItemWebIntegrationInappWebview,
          itemColor: AppColors.pink,
          routeName: Routes.webIntegrationInappWebview,
        ),
      ];
}
