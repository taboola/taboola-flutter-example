import 'package:flutter/material.dart';

import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_sdk/classic/taboola_classic_listener.dart';
import 'package:taboola_sdk/classic/taboola_classic.dart';

TaboolaClassicBuilder taboolaClassicBuilder =
Taboola.getTaboolaClassicBuilder("http://www.example.com", "article");

final List<String> items = List.generate(10, (index) => "Item $index");

class CustomListViewPageFeedAndWidget extends StatelessWidget {
  const CustomListViewPageFeedAndWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    Taboola.init(PublisherInfo("sdk-tester-rnd"));

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        },),
        title: const Text("ListView Example"),
      ),
      body:
      ListView.builder(
        controller:_scrollController ,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return setContainer(index,_scrollController);
        },
      ),
    );
  }
}

Container setContainer(int index,scroll) {
  if (index == 5) {
    return Container(
        color: Colors.teal[100 * (index % 9)],
        height: 300,
        child: setListContent(index,scroll));
  }

  else if(index == 9){
    return Container(
        color: Colors.teal[100 * (index % 9)],
        height: 1600,
        child: setListContent(index,scroll));
  }

  return Container(
      color: Colors.teal[100 * (index % 9)],
      height: 200,
      child: setListContent(index,scroll));
}

Widget setListContent(int index, ScrollController scroll) {
  if (index == 5) {
    TaboolaClassicListener taboolaClassicListener = TaboolaClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);

    TaboolaClassicUnit taboolaClassicUnit = taboolaClassicBuilder.build(
        "mid article widget",
        "alternating-1x2-widget",
        false,
        taboolaClassicListener,viewId:123,scrollController: scroll);
    return taboolaClassicUnit;
  }

  if (index == 9) {
    TaboolaClassicListener taboolaClassicListener2 = TaboolaClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);

    TaboolaClassicUnit taboolaClassicfeed = taboolaClassicBuilder.build(
        "Feed without video", "thumbs-feed-01", true, taboolaClassicListener2,viewId:123333,scrollController: scroll);
    return taboolaClassicfeed;
  }
  return Text('List item $index');
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
