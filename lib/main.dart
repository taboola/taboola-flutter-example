import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/pages/custom_list_view_page_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_feed_and_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_widget.dart';
import 'package:taboola_flutter_example/widgets/menu_item.dart';
import 'package:taboola_sdk/taboola.dart';

import 'package:taboola_flutter_example/constants/publisher_params.dart';
import 'data/menu_items.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Taboola.init(TBLPublisherInfo(PublisherParams.publisherNameKey));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'lib/assets/taboola-logo.png',
              height: 100, // Adjust the height as needed
            ),
          ),
        ),
        const SliverAppBar(
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Taboola Flutter Plugin',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          ),
        ),
      ],
    ));
  }
}
