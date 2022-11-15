
import 'package:flutter/material.dart';
import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_sdk/classic/taboola_classic_listener.dart';
import 'package:taboola_sdk/classic/taboola_classic.dart';

bool shouldDisplayTaboolaFeed = false;
TaboolaWidgetsState widgetsState = TaboolaWidgetsState();
const TaboolaWidgets taboolaWidgets = TaboolaWidgets();

class CustomScrollViewPageFeedAndWidget extends StatelessWidget {
  const CustomScrollViewPageFeedAndWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    widgetsState = TaboolaWidgetsState();
    return (const TaboolaWidgets());
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
    Taboola.init(PublisherInfo("sdk-tester-rnd"));
    TaboolaClassicBuilder taboolaClassicBuilder =
        Taboola.getTaboolaClassicBuilder("http://www.example.com", "article");
    TaboolaClassicListener taboolaClassicListener = TaboolaClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);
    TaboolaClassicUnit taboolaClassicUnit = taboolaClassicBuilder.build(
        "mid article widget",
        "alternating-1x2-widget",
        false,
        taboolaClassicListener,
        viewId: 123);
    TaboolaClassicUnit taboolaClassicfeed = taboolaClassicBuilder.build(
        "Feed without video", "thumbs-feed-01", true, taboolaClassicListener,
        viewId: 123);

    return Scaffold(
        appBar: AppBar(
          title: Text("CustoScrollView with Feed"),
        ),
        body: CustomScrollView(
          controller: shouldDisplayTaboolaFeed
              ? taboolaClassicfeed.scrollController
              : null,
          slivers: <Widget>[
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
            SliverToBoxAdapter(
                child: shouldDisplayTaboolaFeed ? taboolaClassicfeed : EmptyWidget()),
          ],
        ));
  }
}

class EmptyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(color: Colors.green );
  }

}

//Taboola classic listeners
void taboolaDidShow(String placement) {
  print("taboolaDidShow");
  widgetsState.enableFeedDisplay();
  
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
