// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';

import 'package:taboola_flutter_example/constants/publisher_params.dart';
import 'package:taboola_flutter_example/constants/ui_constants.dart';
import 'package:taboola_sdk/classic/tbl_classic_listener.dart';
import 'package:taboola_sdk/classic/tbl_classic_page.dart';
import 'package:taboola_sdk/classic/tbl_classic_unit.dart';
import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';

class CustomScrollViewPageFeedAndWidget extends StatefulWidget {
  const CustomScrollViewPageFeedAndWidget({Key? key}) : super(key: key);

  @override
  State<CustomScrollViewPageFeedAndWidget> createState() => _CustomScrollViewPageFeedAndWidgetState();
}

class _CustomScrollViewPageFeedAndWidgetState extends State<CustomScrollViewPageFeedAndWidget> {
  late TBLClassicPage _classicPage;
  late TBLClassicUnit _taboolaClassicFeed;
  late TBLClassicUnit _taboolaClassicUnit;
  late TBLClassicListener _taboolaClassicListener;
  bool _shouldDisplayTaboolaFeed = false;

  @override
  void initState() {
    super.initState();
    _initTaboola();
  }

  void _initTaboola() {
    _classicPage = Taboola.getClassicPage(
        PublisherParams.pageUrl,
        PublisherParams.pageTypeArticle
    );

    _taboolaClassicListener = TBLClassicListener(
        _taboolaDidResize,
        _taboolaDidShow,
        _taboolaDidFailToLoad,
        _taboolaDidClickOnItem
    );

    _taboolaClassicFeed = _classicPage.build(
        PublisherParams.feedPlacementName,
        PublisherParams.feedMode,
        true,
        _taboolaClassicListener,
        viewId: UIConstants.viewId
    );

    _taboolaClassicUnit = _classicPage.build(
        PublisherParams.midArticleWidgetPlacementName,
        PublisherParams.alternatingOneByTwoWidgetMode,
        false,
        _taboolaClassicListener,
        viewId: UIConstants.viewId
    );
    _taboolaClassicUnit.fetchContent();
    _taboolaClassicFeed.fetchContent();
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }

  void _enableFeedDisplay() {
    setState(() {
      _shouldDisplayTaboolaFeed = true;
    });
  }

  //Taboola classic listeners
  void _taboolaDidShow(String placement) {
    print("taboolaDidShow");
    if (!_shouldDisplayTaboolaFeed) {
      _enableFeedDisplay();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.sliverListWithWidgetAndFeed),
        ),
        body: CustomScrollView(
          controller: _shouldDisplayTaboolaFeed
              ? _taboolaClassicFeed.scrollController
              : null,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _taboolaClassicUnit.getWidget,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        color: Colors.lightBlue[100 * (index % UIConstants.colorModBase)],
                        height: UIConstants.listItemHeight,
                        child: Text('${AppStrings.listItemPrefix}$index'),
                      );
                    },
                    childCount: UIConstants.listItemCount
                )
            ),
            SliverToBoxAdapter(
                child: _shouldDisplayTaboolaFeed
                    ? _taboolaClassicFeed.getWidget
                    : const EmptyWidget()
            ),
          ],
        )
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        height: UIConstants.emptyWidgetHeight,
        child: const Text(AppStrings.feedContainer),
        alignment: Alignment.center);
  }
}
