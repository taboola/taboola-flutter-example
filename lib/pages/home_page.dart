import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';
import 'package:taboola_flutter_example/constants/ui_constants.dart';
import 'package:taboola_flutter_example/data/menu_items.dart';
import 'package:taboola_flutter_example/widgets/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = MenuItemRepository.getMenuItems();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: UIConstants.logoPadding,
              child: Image.asset(
                AppStrings.taboolaLogoPath,
                height: UIConstants.logoHeight,
              ),
            ),
          ),
          const SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.appBarTitle,
                style: UIConstants.appBarTitleStyle,
              ),
            ),
          ),
          SliverPadding(
            padding: UIConstants.menuPadding,
            sliver: SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: UIConstants.menuItemBottomPadding),
                  child: MainMenuItem(
                    menuItems[index],
                  ),
                ),
                childCount: menuItems.length,
              ),
              itemExtent: UIConstants.menuItemExtent,
            ),
          ),
        ],
      )
    );
  }
} 