import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:taboola_sdk/classic/tbl_classic.dart';
import 'package:taboola_sdk/classic/tbl_classic_listener.dart';
import 'package:taboola_sdk/classic/tbl_classic_page.dart';
import 'package:taboola_sdk/taboola.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';



TBLClassicPage taboolaClassicBuilder =
    Taboola.getClassicPage("http://www.example.com", "article");

final List<String> items = List.generate(2, (index) => "Item $index");
final ScrollController _scrollController = ScrollController();


class CustomScrollViewWebViewFeed extends StatelessWidget {
  const CustomScrollViewWebViewFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
        
      );


     return CustomScrollView(
        controller: ScrollController(),
        slivers: [
          SliverToBoxAdapter(
              child: SizedBox(height: 700,
                  child: WebViewWidget(controller: controller))),
          SliverToBoxAdapter(
              child: SizedBox(
                  child: taboolaWidget())),
        ],
      );
        
  }

Widget taboolaWidget() {

    TBLClassicListener taboolaClassicListener2 = TBLClassicListener(
        taboolaDidResize,
        taboolaDidShow,
        taboolaDidFailToLoad,
        taboolaDidClickOnItem);

    TBLClassicUnit taboolaClassicfeed = taboolaClassicBuilder.build(
        "Feed without video", "thumbs-feed-01", true, taboolaClassicListener2,
        viewId: 123333, keepAlive: true);
    return taboolaClassicfeed;
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
}
