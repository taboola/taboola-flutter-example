import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/pages/custom_list_view_page_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_feed_and_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_widget.dart';
import 'package:taboola_flutter_example/widgets/menu_item.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_webview_and_feed.dart';

import 'data/menu_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/customscrollviewWidget': (context) => const CustomScrollViewPageWidget(),
        '/customscrollviewfeedAndWidget': (context) => const CustomScrollViewPageFeedAndWidget(),
        '/customlistviewfeedAndWidget': (context) =>  const CustomListViewPageFeedAndWidget(),
        '/CustomScrollViewWebViewFeed' : (context) => const CustomScrollViewWebViewFeed(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final menuItems = MenuItemRepository.getMenuItems();

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Taboola Flutter Plugin v3.0.1'),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MainMenuItem(
                    menuItems[index],
                  ),
                ),
                childCount: menuItems.length,
              ),
              itemExtent: 110,
            )),
      ],
    ));
  }
}
