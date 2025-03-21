import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/models/menu_item_model.dart';

class MainMenuItem extends StatelessWidget {
  final MenuItemModel menuItem;

  const MainMenuItem(
    this.menuItem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => routeToMenuItemPage(context),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: menuItem.itemColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        menuItem.title,
                        style: const TextStyle(
                          fontSize: 20,
                          //  color: AppColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future routeToMenuItemPage(context) {
    return Navigator.pushNamed(context, menuItem.routeName);
  }
}
