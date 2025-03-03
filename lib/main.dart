import 'package:flutter/material.dart';
import 'package:taboola_flutter_example/constants/app_strings.dart';
import 'package:taboola_flutter_example/constants/publisher_params.dart';
import 'package:taboola_flutter_example/constants/routes.dart';
import 'package:taboola_flutter_example/pages/custom_list_view_page_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_feed_and_widget.dart';
import 'package:taboola_flutter_example/pages/custom_scroll_view_page_widget.dart';
import 'package:taboola_flutter_example/pages/home_page.dart';
import 'package:taboola_flutter_example/pages/web_integration_inappwebview_page.dart';
import 'package:taboola_flutter_example/pages/web_integration_page.dart';
import 'package:taboola_sdk_beta/taboola.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Taboola.init(TBLPublisherInfo(PublisherParams.publisherName));
  runApp(const TaboolaExampleApp());
}

class TaboolaExampleApp extends StatelessWidget {
  const TaboolaExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomePage(),
        Routes.customScrollViewWidget: (context) => const CustomScrollViewPageWidget(),
        Routes.customScrollViewFeedAndWidget: (context) => const CustomScrollViewPageFeedAndWidget(),
        Routes.customListViewFeedAndWidget: (context) => const CustomListViewPageFeedAndWidget(),
        Routes.webIntegration: (context) => const WebIntegrationPage(),
        Routes.webIntegrationInappWebview: (context) => const WebIntegrationInappWebviewPage(),
      },
    );
  }
}
