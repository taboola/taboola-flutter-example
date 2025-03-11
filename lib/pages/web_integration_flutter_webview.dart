import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/constants/ui_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:taboola_sdk/taboola.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';

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
<div id='taboola1'>
</div>


<script type='text/javascript'>
    window._taboola = window._taboola || [];

   _taboola.push({
             article: 'auto',
             url: ''
         });

    _taboola.push({
        mode: 'alternating-widget-with-video',
        container: 'taboola1',
        placement: 'Mid Article',
        target_type: 'article'
    });

    _taboola["mobile"] = [];
    _taboola["mobile"].push({
        // true - will allow lazy data loading on fetch, false - will load automatically without waiting
         lazyFetch: false,
        // run sdkless when testing the js on a browser (no sdk) (optional)
        allow_sdkless_load:false,

        // set view id in order to prevent duplicated between different placements (optional)
        taboola_view_id:new Date().getTime(),

        // override publisher from script url
        publisher:"sdk-tester-rnd"
    });
    _taboola.push({
        flush: true
    });
</script>
</body>
</html>
''';

class WebIntegrationFlutterWebview extends StatefulWidget {
  const WebIntegrationFlutterWebview({Key? key}) : super(key: key);

  @override
  State<WebIntegrationFlutterWebview> createState() => _WebIntegrationFlutterWebviewState();
}

class _WebIntegrationFlutterWebviewState extends State<WebIntegrationFlutterWebview> {
  late final WebViewController _webViewController;
  late final TBLWebUnit _taboolaWebUnit;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _webViewController  = WebViewController.fromPlatformCreationParams(params);
    // Create Taboola web listener
    TBLWebListener tblWebListener = TBLWebListener(
      tblDidResize,
      tblDidShow,
      tblDidFailToLoad,
      tblDidClickOnItem,
    );

    // Initialize Taboola web page and unit
    TBLWebPage webPage = Taboola.getWebPage();
    _taboolaWebUnit = webPage.buildWebUnit(
        _webViewKey, _webViewController, tblWebListener,
        scrollController: _scrollController);

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(kLocalExamplePage);
  }

  @override
  void dispose() {
    _taboolaWebUnit.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(AppStrings.taboolaWebIntegration),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(_buildList(UIConstants.webListLength)),
          ),
          SliverToBoxAdapter(
            child: Container(
              key: _webViewKey,
              height: UIConstants.webContainerHeight,
              child: WebViewWidget(
                controller: _webViewController,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildList(UIConstants.webListLength)),
          )
        ],
      ),
    );
  }

  List<Widget> _buildList(int count) {
    List<Widget> listItems = [];
    for (int i = 0; i < count; i++) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.all(UIConstants.listItemPadding),
          child: Text(
            '${AppStrings.itemPrefix}$i',
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      );
    }
    return listItems;
  }

  // Callback when the ad is shown
  void tblDidShow(String placement) {
    print("tblDidShow for placement: $placement");
    _showSnackBar("${AppStrings.adShownMessage}$placement");
  }

  // Callback when the ad is resized
  void tblDidResize(String placement, double height) {
    print("Publisher did get height $height");
    _showSnackBar("${AppStrings.adResizedMessage}$placement${AppStrings.adResizedHeightMessage}$height");
  }

  // Callback when the ad fails to load
  void tblDidFailToLoad(String placement, String error) {
    print("Publisher placement: $placement did fail with error: $error");
    _showSnackBar("${AppStrings.adFailedMessage}$placement${AppStrings.adFailedErrorMessage}$error");
  }

  // Callback when an item is clicked
  bool tblDidClickOnItem(
      String placement, String itemId, String clickUrl, bool organic) {
    print(
        "Publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement; organic: $organic");
    if (organic) {
      _showSnackBar(AppStrings.organicClickMessage);
      print("organic");
    } else {
      _showSnackBar(AppStrings.sponsoredClickMessage);
      print("SC");
    }
    return false;
  }

  // Helper method to show a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: AppStrings.okButton,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
} 