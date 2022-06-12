import 'package:flutter/material.dart';

import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_sdk/standard/taboola_standard_listener.dart';
import 'package:taboola_sdk/standard/taboola_standard.dart';

class CustomScrollViewPage extends StatelessWidget {
  const CustomScrollViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Taboola.init(PublisherInfo("sdk-tester-rnd"));

    TaboolaStandardBuilder taboolaStandardBuilder =
        Taboola.getTaboolaStandardBuilder("http://www.example.com", "article");

    TaboolaStandardListener taboolaStandardListener = TaboolaStandardListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);

    TaboolaStandard taboolaStandard = taboolaStandardBuilder.build(
        "Feed without video", "thumbs-feed-01", true, taboolaStandardListener);

    return Scaffold(
        appBar: AppBar(
          title: Text("CustoScrollView with Feed"),
        ),
        body: CustomScrollView(
          controller: taboolaStandard.scrollController,
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
            }, childCount: 20)),
            SliverToBoxAdapter(
              child: taboolaStandard,
            ),
          ],
        ));
  }
}

//Taboola Standard listeners
void taboolaDidShow(String placement) {
  print("taboolaDidShow");
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
