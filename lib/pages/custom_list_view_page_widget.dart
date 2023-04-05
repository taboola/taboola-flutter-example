import 'dart:async';

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
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("ListView Example"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return setContainer(index, _scrollController);
        },
      ),
    );
  }
}

Container setContainer(int index, scroll) {
  if (index == 5) {
    return Container(
        color: Colors.teal[100 * (index % 9)],
        height: 300,
        child: setListContent(index, scroll));
  } else if (index == 9) {
    return Container(
        color: Colors.teal[100 * (index % 9)],
        height: 1600,
        child: setListContent(index, scroll));
  }

  return Container(
      color: Colors.teal[100 * (index % 9)],
      height: 200,
      child: setListContent(index, scroll));
}

Widget setListContent(int index, ScrollController scroll) {
  if (index == 5) {

    return const ClassicUnitWrapper(placement:  "mid article widget", taboolaType: "alternating-1x2-widget",);
  }

  if (index == 9) {

    return const ClassicUnitWrapper(placement:  "Feed without video", taboolaType: "thumbs-feed-01",);
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
class ClassicUnitWrapper extends StatefulWidget {
  final String placement;
  final String taboolaType;

  const ClassicUnitWrapper({Key? key, required this.placement, required this.taboolaType}) : super(key: key);

  @override
  _ClassicUnitWrapperState createState() => _ClassicUnitWrapperState();
}

class _ClassicUnitWrapperState extends State<ClassicUnitWrapper> with AutomaticKeepAliveClientMixin<ClassicUnitWrapper> {

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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    TaboolaClassicListener taboolaClassicListener2 = TaboolaClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);
    return taboolaClassicBuilder.build(
        widget.placement, widget.taboolaType, true, taboolaClassicListener2);
  }

  @override
  bool get wantKeepAlive => true;

}