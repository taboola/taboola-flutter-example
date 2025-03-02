import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:taboola_sdk_beta/taboola.dart';

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

<p>ZOOOONam euismod mauris id sapien mattis interdum. Curabitur ligula turpis, efficitur vitae est
    id,
    porttitor tempus diam. Phasellus nec lacus rhoncus mauris facilisis feugiat. Cras blandit
    dignissim facilisis. In blandit purus odio, sagittis porta neque rutrum vitae. Vestibulum
    consectetur, arcu et venenatis pulvinar, arcu lorem viverra nunc, commodo eleifend velit mauris
    eget eros. Proin pretium ex vel quam dapibus dictum.
</p>
<div id='taboola1'>
</div>




<p>
    <a href="https://example.com">some link on the publisher page</a>
</p>


<div id='above_article_container'>
</div>

<script type='text/javascript'>
    window._taboola = window._taboola || [];

   _taboola.push({
             article: 'auto',
             url: ''
         });

    _taboola.push({
        mode: 'thumbs-feed-01',
        container: 'taboola1',
        placement: 'Feed without video',
        target_type: 'mix'
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

class WebIntegrationInappWebviewPage extends StatefulWidget {
  const WebIntegrationInappWebviewPage({Key? key}) : super(key: key);
  
  @override
  _WebIntegrationInappWebviewPageState createState() =>
      _WebIntegrationInappWebviewPageState();
}

class _WebIntegrationInappWebviewPageState
    extends State<WebIntegrationInappWebviewPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late TBLWebUnit tblWebUnit;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tblWebUnit.dispose();
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
          title: const Text("Taboola InAppWebView Integration"),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  onWebViewCreated: (inappwebviewController) async {
                    TBLWebListener tblWebListener = TBLWebListener(
                      _tblDidResize,
                      _tblDidShow,
                      _tblDidFailToLoad,
                      _tblDidClickOnItem,
                    );
                    TBLWebPage webPage = Taboola.getWebPage();
                    tblWebUnit = webPage.buildWebUnit(
                      webViewKey,
                      inappwebviewController,
                      tblWebListener,
                    );

                    inappwebviewController.loadData(data: kLocalExamplePage);
                  },
                ),
              ],
            ),
          ),
        ])));
  }

  void _tblDidShow(String placement) {
    print("tblDidShow for placement: $placement");
    _showToast("Ad shown for placement: $placement");
  }

  void _tblDidResize(String placement, double height) {
    print("Ad resized for placement $placement to height $height");
    _showToast("Ad resized for placement: $placement to height: $height");
  }

  void _tblDidFailToLoad(String placement, String error) {
    print("Ad failed to load for placement: $placement with error: $error");
    _showToast("Ad failed for placement: $placement\nError: $error");
  }

  bool _tblDidClickOnItem(
      String placement, String itemId, String clickUrl, bool organic) {
    print(
        "Publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement of organic: $organic");
    if (organic) {
      _showToast("Publisher opted to open click but didn't actually open it.");
      print("organic");
    } else {
      _showToast(
          "Publisher opted to open clicks but the item is Sponsored, SDK retains control.");
      print("SC");
    }
    return false;
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
} 