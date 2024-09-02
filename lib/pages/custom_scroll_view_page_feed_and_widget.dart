// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:taboola_sdk/classic/tbl_classic.dart';
import 'package:taboola_sdk/classic/tbl_classic_listener.dart';
import 'package:taboola_sdk/classic/tbl_classic_page.dart';
import 'package:taboola_sdk/taboola.dart';

import '../constants/publisher_params.dart';

bool shouldDisplayTaboolaFeed = false;
TaboolaWidgetsState widgetsState = TaboolaWidgetsState();
const TaboolaWidgets taboolaWidgets = TaboolaWidgets();
TBLClassicPage classicPage =
    Taboola.getClassicPage(PublisherParams.pageUrlKey, PublisherParams.pageTypeKey);
TBLClassicListener taboolaClassicListener = TBLClassicListener(taboolaDidResize,
    taboolaDidShow, taboolaDidFailToLoad, taboolaDidClickOnItem);
TBLClassicUnit taboolaClassicfeed = classicPage.build(
    PublisherParams.feedPlacementNameKey,
    PublisherParams.feedModeKey,
    true,
    taboolaClassicListener,
    viewId: 123);

const viewID = 123;

class CustomScrollViewPageFeedAndWidget extends StatelessWidget {
  const CustomScrollViewPageFeedAndWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TBLClassicUnit taboolaClassicUnit = classicPage.build(PublisherParams.midArticleWidgetPlacementNameKey,
        PublisherParams.alternating1x2WidgetModeKey, false, taboolaClassicListener,
        viewId: viewID);

    shouldDisplayTaboolaFeed = false;
    widgetsState = TaboolaWidgetsState();
    //return (const TaboolaWidgets());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sliver List with Widget & Feed"),
        ),
        body: CustomScrollView(
          controller: shouldDisplayTaboolaFeed
              ? taboolaClassicfeed.scrollController
              : null,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: taboolaClassicUnit,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                height: 50,
                child: Text('List Item $index'),
              );
            }, childCount: 10)),
            const TaboolaWidgets()
          ],
        ));
  }
}

class TaboolaWidgets extends StatefulWidget {
  const TaboolaWidgets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => widgetsState;
}

class TaboolaWidgetsState extends State<TaboolaWidgets> {
  void enableFeedDisplay() {
    setState(() {
      shouldDisplayTaboolaFeed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: shouldDisplayTaboolaFeed
            ? taboolaClassicfeed
            : const EmptyWidget());
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        height: 100,
        child: const Text("Feed Container"),
        alignment: Alignment.center);
  }
}

//Taboola classic listeners
void taboolaDidShow(String placement) {
  print("taboolaDidShow");
  if (shouldDisplayTaboolaFeed == false) {
    widgetsState.enableFeedDisplay();
  }
}

void taboolaDidResize(String placement, double height) {
  print("publisher did get height $height");
}

void taboolaDidFailToLoad(String placement, String error) {
  print("publisher placement:$placement did fail with an error:$error");
}

bool taboolaDidClickOnItem(
    String placement, String itemId, String clickUrl, bool organic) {
  print(
      "publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement of organic: $organic");
  if (organic) {
    //_showToast("Publisher opted to open click but didn't actually open it.");
    print("organic");
  } else {
    // _showToast("Publisher opted to open clicks but the item is Sponsored, SDK retains control.");
    print("SC");
  }
  return false;
}
