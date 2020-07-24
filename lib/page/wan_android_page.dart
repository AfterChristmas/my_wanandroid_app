import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/common/app_colors.dart';
import 'package:my_wanandroid_app/common/application.dart';
import 'package:my_wanandroid_app/constant/routes.dart';
import 'package:event_bus/event_bus.dart';
import 'package:my_wanandroid_app/page/know_system_tree_page.dart';
import 'package:my_wanandroid_app/page/myinfo_page.dart';

import 'home_list_page.dart';

class WanAndroidApp extends StatelessWidget {
  WanAndroidApp() {
    Routes.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routes.routes,
      home: WanAndroidHomePage(),
    );
  }
}

class WanAndroidHomePage extends StatefulWidget {
  WanAndroidHomePage({Key key}) : super(key: key);

  @override
  _WanAndroidHomePageState createState() {
    return _WanAndroidHomePageState();
  }
}

class _WanAndroidHomePageState extends State<WanAndroidHomePage> {
  var currentPage = 0;
  PageController _pageController;
  final appBarTitles = ['首页', '知识体系', '我的'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Application.eventBus = EventBus();
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: AppColors.colorPrimary,
          accentColor: AppColors.accentColor,
          textTheme: TextTheme(
              body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0)),
          iconTheme: IconThemeData(color: AppColors.iconColor, size: 25.0)),
      routes: Routes.routes,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[currentPage],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                _gotoSearchPage();
              },
            )
          ],
        ),
        body: getBody(),
      ),
    );
  }

  void _gotoSearchPage() {}

  getBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            children: <Widget>[
              HomeListPage(),
              KnowSystemTreePage(),
              MyInfoPage(),
            ],
            controller: _pageController,
            //滑动的那种控制,
            // BouncingScrollPhysics是用来适用于
            // 允许滚动偏移超出内容范围，然后将内容反弹到那些范围边缘的环境的滚动物理。iOS上经常有这种效果
            //NeverScrollableScrollPhysics  可以禁止滑动
            physics: BouncingScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),
        ),
        BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text(appBarTitles[0])),
            BottomNavigationBarItem(
                icon: Icon(Icons.widgets), title: Text(appBarTitles[1])),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text(appBarTitles[2])),
          ],
          onTap: (page) {
            _pageController.jumpToPage(page);
          },
          currentIndex: currentPage,
        )
      ],
    );
  }
}
