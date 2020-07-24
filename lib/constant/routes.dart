import 'package:flutter/cupertino.dart';
import 'package:my_wanandroid_app/page/login/login_page.dart';
import 'package:my_wanandroid_app/page/webview/web_view_page.dart';

class Routes {
  static String root = "/";

  static Map<String, WidgetBuilder> routes = {};

  //webview
  static String webViewPage = '/web_view_page';
  static String loginPage = '/login_page1';

  static void init() {
    routes[webViewPage] = (context) => WebViewPage();
    routes[loginPage] = (context) => LoginPage();
  }
}
