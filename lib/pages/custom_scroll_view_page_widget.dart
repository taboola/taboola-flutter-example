import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/constants/publisher_params.dart';
import 'package:taboola_flutter_example/constants/ui_constants.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_listener.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_page.dart';
import 'package:taboola_sdk_beta/classic/tbl_classic_unit.dart';
import 'package:taboola_sdk_beta/taboola.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';

class CustomScrollViewPageWidget extends StatefulWidget {
  const CustomScrollViewPageWidget({Key? key}) : super(key: key);

  @override
  State<CustomScrollViewPageWidget> createState() => _CustomScrollViewPageWidgetState();
}

class _CustomScrollViewPageWidgetState extends State<CustomScrollViewPageWidget> {
  late TBLClassicListener _taboolaClassicListener;
  late TBLClassicPage _taboolaClassicBuilder;
  late TBLClassicUnit _taboolaClassicUnit;

  @override
  void initState() {
    super.initState();
    _initTaboola();
  }

  void _initTaboola() {
    _taboolaClassicListener = TBLClassicListener(
        _taboolaDidResize,
        _taboolaDidShow,
        _taboolaDidFailToLoad,
        _taboolaDidClickOnItem
    );

    _taboolaClassicBuilder = Taboola.getClassicPage(
        PublisherParams.pageUrl,
        PublisherParams.pageTypeArticle
    );

    _taboolaClassicUnit = _taboolaClassicBuilder.build(
        PublisherParams.midArticleWidgetPlacementName,
        PublisherParams.alternatingOneByTwoWidgetMode,
        false,
        _taboolaClassicListener
    );

    // Fetch content once during initialization
    _taboolaClassicUnit.fetchContent();
  }

  @override
  void dispose() {
    // Add any necessary cleanup here
    super.dispose();
  }

  // Taboola Standard listeners
  void _taboolaDidShow(String placement) {
    print("taboolaDidShow");
  }

  void _taboolaDidResize(String placement, double height) {
    print("publisher did get height $height");
  }

  void _taboolaDidFailToLoad(String placement, String error) {
    print("publisher placement:$placement did fail with an error:$error");
  }

  bool _taboolaDidClickOnItem(
      String placement, String itemId, String clickUrl, bool organic) {
    print(
        "publisher did click on item: $itemId with clickUrl: $clickUrl in placement: $placement of organic: $organic");
    if (organic) {
      print("organic");
    } else {
      print("SC");
    }
    return false;
  }

  Widget _setGridItemContent(int index) {
    if (index == UIConstants.taboolaWidgetPosition) {
      return _taboolaClassicUnit.getWidget;
    }
    return Text('${AppStrings.gridItemPrefix}$index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.sliverGridWithWidget),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: UIConstants.maxCrossAxisExtent,
                mainAxisSpacing: UIConstants.mainAxisSpacing,
                crossAxisSpacing: UIConstants.crossAxisSpacing,
                childAspectRatio: UIConstants.childAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                      alignment: Alignment.center,
                      color: Colors.teal[100 * (index % UIConstants.colorModBase)],
                      child: _setGridItemContent(index)
                  );
                },
                childCount: UIConstants.gridItemCount,
              ),
            ),
          ],
        )
    );
  }
}
