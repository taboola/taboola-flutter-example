import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:taboola_sdk_beta/taboola.dart';

import 'package:taboola_flutter_example/utils/snack_bar_utils.dart';
import 'package:taboola_flutter_example/utils/webview_utils.dart';

const String kLocalExamplePage = '''
<html>
  <!DOCTYPE html>
<head>
    <meta name='viewport' content='width=device-width, user-scalable=no'/>

    <script type="text/javascript">
        window._taboola = window._taboola || [];
        _taboola.push({"article": 'auto', url: ''});
        !function (e, f, u, i) {
            if (!document.getElementById(i)) {
                e.async = 1;
                e.src = u;
                e.id = i;
                f.parentNode.insertBefore(e, f);
            }
        } (document.createElement('script'),
            document.getElementsByTagName('script')[0],
            'https://cdn.taboola.com/libtrc/sdk-tester-rnd/mobile-loader.js',
            'tb-mobile-loader-script');

    </script>
</head>
<body>
<div id='taboola'>
</div>


</div>

<script type='text/javascript'>
    window._taboola = window._taboola || [];

   _taboola.push({
             article: 'auto',
             url: ''
         });


    
    // Second placement
    _taboola.push({
        mode: 'alternating-widget-with-video',
        container: 'taboola',
        placement: 'Bottom Article',
        target_type: 'article'
    });

    _taboola["mobile"] = [];
    _taboola["mobile"].push({
        lazyFetch: false,
        allow_sdkless_load: false,
        taboola_view_id: new Date().getTime(),
        publisher: "sdk-tester-rnd"
    });
    _taboola.push({
        flush: true
    });
</script>
</body>
</html>
''';

class WebIntegrationTwoWebUnitsScreen extends StatefulWidget {
  const WebIntegrationTwoWebUnitsScreen({Key? key}) : super(key: key);

  @override
  State<WebIntegrationTwoWebUnitsScreen> createState() => _WebIntegrationTwoWebUnitsScreenState();
}

class _WebIntegrationTwoWebUnitsScreenState extends State<WebIntegrationTwoWebUnitsScreen>
    with SnackBarMixin {
  late final WebViewController _topWebViewController;
  late final WebViewController _bottomWebViewController;
  late final TBLWebUnit _topTaboolaWebUnit;
  late final TBLWebUnit _bottomTaboolaWebUnit;
  late final TBLWebPage _tblWebPage;
  final int LIST_LENGTH = 10;
  final ScrollController _scrollController = ScrollController();

  // Keys for each WebView container
  final GlobalKey _topWebViewKey = GlobalKey();
  final GlobalKey _bottomWebViewKey = GlobalKey();

  // Style
  final double CONTAINER_HEIGHT = 600;
  final double LIST_ITEM_PADDING = 20.0;

  @override
  void initState() {
    super.initState();
    _topWebViewController = WebViewUtils.createWebViewController();
    _bottomWebViewController = WebViewUtils.createWebViewController();

    // Initialize TBLWebPage
    _tblWebPage = Taboola.getWebPage();

    // Create listeners for both units
    TBLWebListener topListener = TBLWebListener(
        tblDidResize, tblDidShow, tblDidFailToLoad, tblDidClickOnItem, _onUpdateContentCompleted);

    TBLWebListener bottomListener = TBLWebListener(
        tblDidResize, tblDidShow, tblDidFailToLoad, tblDidClickOnItem, _onUpdateContentCompleted);

    // Initialize both web units
    _topTaboolaWebUnit = _tblWebPage.buildWebUnit(
        _topWebViewKey, _topWebViewController, topListener,
        scrollController: _scrollController);

    _bottomTaboolaWebUnit = _tblWebPage.buildWebUnit(
        _bottomWebViewKey, _bottomWebViewController, bottomListener,
        scrollController: _scrollController);

    // // Log view IDs
    print("Top WebUnit ViewID: ${_topTaboolaWebUnit.viewId}");
    print("Bottom WebUnit ViewID: ${_bottomTaboolaWebUnit.viewId}");

    _topWebViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(kLocalExamplePage);

    _bottomWebViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(kLocalExamplePage);
  }

  @override
  void dispose() {
    // Clear all widgets and dispose of web units
    _tblWebPage.clearAllWidgets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dual Taboola WebUnits'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Test refreshPage function
              _tblWebPage.refreshPage();
              showSnackBar("Refreshed all Taboola units");
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(_buildList(LIST_LENGTH, "Top")),
          ),
          // Top Taboola WebUnit
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text("Top Taboola Unit", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: () {
                      _topTaboolaWebUnit.refresh();
                      showSnackBar("Refreshed top Taboola unit");
                    },
                    child: Text('Refresh Top Unit')),
                Container(
                  key: _topWebViewKey,
                  height: CONTAINER_HEIGHT,
                  child: WebViewWidget(
                    controller: _topWebViewController,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildList(LIST_LENGTH, "Middle")),
          ),
          // Bottom Taboola WebUnit
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text("Bottom Taboola Unit", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: () {
                      _bottomTaboolaWebUnit.refresh();
                      showSnackBar("Refreshed bottom Taboola unit");
                    },
                    child: Text('Refresh Bottom Unit')),
                Container(
                  key: _bottomWebViewKey,
                  height: CONTAINER_HEIGHT,
                  child: WebViewWidget(
                    controller: _bottomWebViewController,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildList(LIST_LENGTH, "Bottom")),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList(int count, String section) {
    List<Widget> listItems = [];
    for (int i = 0; i < count; i++) {
      listItems.add(
        Padding(
          padding: EdgeInsets.all(LIST_ITEM_PADDING),
          child: Text(
            '$section Item $i',
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      );
    }
    return listItems;
  }

  // Callback when the ad is shown.
  void tblDidShow(String placement) {
    showSnackBar("Ad shown for placement: $placement");
  }

  // Callback when the ad is resized.
  void tblDidResize(String placement, double height) {
    showSnackBar("Ad resized for placement: $placement to height: $height");
  }

  // Callback when the ad fails to load.
  void tblDidFailToLoad(String placement, String error) {
    showSnackBar("Ad load failed for placement: $placement\nError: $error");
  }

  // Callback when an item is clicked.
  bool tblDidClickOnItem(String placement, String itemId, String clickUrl, bool organic) {
    print(
        "Publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement; organic: $organic");
    if (organic) {
      showSnackBar("Clicked on organic item in placement: $placement");
    } else {
      showSnackBar("Clicked on sponsored item in placement: $placement");
    }
    return false;
  }

  void _onUpdateContentCompleted() {
    showSnackBar("Content update completed");
  }
}
