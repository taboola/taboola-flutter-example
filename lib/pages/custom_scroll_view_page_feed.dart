import 'package:flutter/material.dart';

import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_sdk/classic/taboola_classic_listener.dart';
import 'package:taboola_sdk/classic/taboola_classic.dart';

class CustomScrollViewPageFeed extends StatelessWidget {
  const CustomScrollViewPageFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Taboola.init(PublisherInfo("sdk-tester-rnd"));

    TaboolaClassicBuilder taboolaClassicBuilder = Taboola.getTaboolaClassicBuilder("http://www.example.com", "article");

     TaboolaClassicListener taboolaClassicListener = TaboolaClassicListener(taboolaDidResize, taboolaDidShow, taboolaDidFailToLoad, taboolaDidClickOnItem);

     TaboolaClassicUnit taboolaClassicfeed = taboolaClassicBuilder.build("Feed without video", "thumbs-feed-01", true,taboolaClassicListener, viewId: 2);

    return Scaffold(
        appBar: AppBar(
          title: Text("CustoScrollView with Feed"),
        ),
        body: CustomScrollView(
          controller: taboolaClassicfeed.scrollController,
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
              child: taboolaClassicfeed,
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
