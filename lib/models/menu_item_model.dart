import 'package:flutter/material.dart';

@immutable
class MenuItemModel {
  final String title;
  final Color itemColor;
  final String routeName;

  const MenuItemModel({
    required this.title,
    required this.itemColor,
    required this.routeName,
  });
}
