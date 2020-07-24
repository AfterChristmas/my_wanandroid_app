import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/constant/api.dart';
import 'package:my_wanandroid_app/constant/routes.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/page/webview/route_web_page_data.dart';
import 'package:my_wanandroid_app/util/log_util.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_wanandroid_app/util/tool_utils.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key}) : super(key: key);

  @override
  _WebViewPageState createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  RouteWebPageData pageData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initData();
    LogUtil.d("访问的url:${pageData.url}");
    WebviewScaffold webviewScaffold = WebviewScaffold(
      url: pageData.url,
      appBar: getAppBar(),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );
    return webviewScaffold;
  }

  void initData() {
    pageData = ModalRoute.of(context).settings.arguments as RouteWebPageData;
    if (pageData == null) {
      pageData = RouteWebPageData();
    }
    if (pageData.url == null || pageData.url == "") {
      pageData.title = "首页";
      pageData.url = Api.BASE_URL;
    }
  }

  getAppBar() {
    AppBar app = ToolUtils.getCommonAppBar(
        context, ToolUtils.signToStr(pageData.title),
        fontSize: 14.0,
        actions: [
          IconButton(
            icon: Icon(ToolUtils.getNotNullBool(pageData.collect)
                ? Icons.favorite
                : Icons.favorite_border),
            color: ToolUtils.getNotNullBool(pageData.collect)
                ? Colors.red
                : Colors.white,
            onPressed: _collectActicle,
          ),
          IconButton(
            icon: Icon(
              Icons.link,
              color: Colors.white,
            ),
            onPressed: _launchUrl,
          )
        ]);
    return app;
  }

  Future<void> _collectActicle() async {
    bool loginState = await dataUtils.isLogin();
    LogUtil.d("loginState::" + loginState.toString());
    if (!loginState) {
      Navigator.pushNamed(context, Routes.loginPage);
    } else {
      if (pageData.collect) {
        var data = await dataUtils.cancelCollectArticle(pageData.id);
        ToolUtils.showToast(msg: "取消收藏成功");
        setState(() {
          pageData.collect = false;
        });
      } else {
        var data = await dataUtils.collectArticle(pageData.id);
        ToolUtils.showToast(msg: "收藏成功");
        setState(() {
          pageData.collect = true;
        });
      }
    }
  }

  ///用系统浏览器打开
  void _launchUrl() async {
    String url = pageData.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToolUtils.showToast(msg: "打开浏览器失败");
    }
  }
}
