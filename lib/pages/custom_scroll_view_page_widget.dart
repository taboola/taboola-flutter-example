import 'package:flutter/material.dart';

import 'package:taboola_sdk/taboola.dart';
import 'package:taboola_sdk/classic/taboola_classic_listener.dart';
import 'package:taboola_sdk/classic/taboola_classic.dart';

class CustomScrollViewPageWidget extends StatelessWidget {
  const CustomScrollViewPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Taboola.init(PublisherInfo("sdk-tester-rnd"));



    return Scaffold(
        appBar: AppBar(
          title: Text("Sliver Grid With Widget"),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.teal[100 * (index % 9)],
                    child: setGridItemContent(index)
                  );
                },
                childCount: 10,
              ),
            ),
          ],
        ));
  }
}

Widget setGridItemContent(int index){
  
  if(index == 5 ){
    TaboolaClassicBuilder taboolaClassicBuilder = Taboola.getTaboolaClassicBuilder("http://www.example.com", "article");

    TaboolaClassicListener taboolaClassicListener = TaboolaClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);

    TaboolaClassicUnit taboolaClassicUnit = taboolaClassicBuilder.build("mid article widget","alternating-1x2-widget", false, taboolaClassicListener);
    return taboolaClassicUnit;
  }
  return Text('grid item $index');
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
