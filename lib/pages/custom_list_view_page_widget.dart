import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/constants/publisher_params.dart';
import 'package:taboola_flutter_example/constants/ui_constants.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_listener.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_page.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_unit.dart';
import 'package:taboola_sdk_beta/taboola.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';

class CustomListViewPageFeedAndWidget extends StatefulWidget {
  const CustomListViewPageFeedAndWidget({Key? key}) : super(key: key);

  @override
  State<CustomListViewPageFeedAndWidget> createState() =>
      _CustomListViewPageFeedAndWidgetState();
}

class _CustomListViewPageFeedAndWidgetState
    extends State<CustomListViewPageFeedAndWidget> {
  late TBLClassicPage _classicPage;
  late ScrollController _scrollController;
  late TBLClassicUnit _taboolaClassicWidget;
  late TBLClassicUnit _taboolaClassicFeed;

  final List<String> _items = List.generate(UIConstants.listLength, (index) => "Item $index");

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initTaboola();
  }

  void _initTaboola() {
    _classicPage = Taboola.getClassicPage(
        PublisherParams.pageUrl, PublisherParams.pageTypeArticle);

    // Create widget unit
    _taboolaClassicWidget = _classicPage.build(
      PublisherParams.midArticleWidgetPlacementName,
      PublisherParams.alternatingOneByTwoWidgetMode,
      false,
      TBLClassicListener(_taboolaDidResize, _taboolaDidShow,
          _taboolaDidFailToLoad, _taboolaDidClickOnItem),
      viewId: UIConstants.widgetViewId,
      scrollController: _scrollController,
    );

    // Create feed unit
    _taboolaClassicFeed = _classicPage.build(
      PublisherParams.feedPlacementName,
      PublisherParams.feedMode,
      true,
      TBLClassicListener(_taboolaDidResize, _taboolaDidShow,
          _taboolaDidFailToLoad, _taboolaDidClickOnItem),
      viewId: UIConstants.feedViewId,
      scrollController: _scrollController,
    );
    _taboolaClassicWidget.fetchContent();
    _taboolaClassicFeed.fetchContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Taboola listener callbacks
  void _taboolaDidShow(String placement) {
    print("taboolaDidShow");
  }

  void _taboolaDidResize(String placement, double height) {
    print("publisher did get height $height");
  }

  void _taboolaDidFailToLoad(String placement, String error) {
    print("publisher placement:$placement did fail with an error:$error");
  }

  bool _taboolaDidClickOnItem(
      String placement, String itemId, String clickUrl, bool organic) {
    print(
        "publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement of organic: $organic");
    if (organic) {
      print("organic");
    } else {
      print("SC");
    }
    return false;
  }

  Widget _setListContent(int index) {
    if (index == UIConstants.widgetPosition) {
      return _taboolaClassicWidget.getWidget;
    }
    if (index == UIConstants.feedPosition) {
      return _taboolaClassicFeed.getWidget;
    }
    return Text('${AppStrings.listItemPrefix}$index');
  }

  Container _setContainer(int index) {
    if (index == UIConstants.widgetPosition) {
      return Container(
          color: Colors.teal[100 * (index % UIConstants.colorModBase)],
          height: UIConstants.widgetHeight,
          child: _setListContent(index));
    } else if (index == UIConstants.feedPosition) {
      return Container(
          color: Colors.teal[100 * (index % UIConstants.colorModBase)],
          height: UIConstants.feedHeight,
          child: _setListContent(index));
    }

    return Container(
        color: Colors.teal[100 * (index % UIConstants.colorModBase)],
        height: UIConstants.defaultItemHeight,
        child: _setListContent(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(AppStrings.listViewExample),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return _setContainer(index);
        },
      ),
    );
  }
}
