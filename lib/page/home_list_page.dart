import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/common/application.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/data/model/article_entity.dart';
import 'package:my_wanandroid_app/widget/home_banner.dart';
import 'package:my_wanandroid_app/widget/refresh/refresh_page.dart';

import 'item/article_item.dart';

class HomeListPage extends StatefulWidget {
  HomeListPage({Key key}) : super(key: key);

  @override
  _HomeListPageState createState() {
    return _HomeListPageState();
  }
}

class _HomeListPageState extends State<HomeListPage> //保持页面的状态避免重复调用
    with
        AutomaticKeepAliveClientMixin {
  HomeBanner homeBanner = HomeBanner();

  @override
  void initState() {
    super.initState();
    getBannerData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshPage(
            requestApi: getArticleData,
            renderItem: buildItem,
            headerView: _getHeaderView,
            isHaveHeader: true,
          ),
        )
      ],
    );
  }

  _getHeaderView() {
    return homeBanner;
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> getBannerData() async {
    var datas = await dataUtils.getBannerData();
    homeBanner.setBannerData(datas);
    Application.eventBus.fire(BannerDataEvent(datas));
  }

  Future<Map> getArticleData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;

    List<Future> requestList = [];
    if (pageIndex == 0) {
      requestList.add(dataUtils.getTopArticleData());
    }
    requestList.add(dataUtils.getArticleData(pageIndex));

    Map<String, dynamic> result;
    await Future.wait(requestList).then((List listData) {
      //需要将顶部数据List<ArticleData> 和 正常文章数据ArticleDataEntity中的datas进行合并,组成一个新的List
      if (listData == null) {
        result = {"list": listData, "total": 0, 'pageIndex': pageIndex};
      } else {
        List<ArticleData> articleAllList = [];
        var totalCount = 0;
        for (var value in listData) {
          if (value is List<ArticleData>) {
            articleAllList.addAll(value);
          } else if (value is ArticleEntity) {
            articleAllList.addAll(value.datas);
            totalCount = value.total;
          }
        }
        pageIndex++;
        result = {
          "list": articleAllList,
          'total': totalCount,
          'pageIndex': pageIndex
        };
      }
    });
    return result;
  }

  Widget buildItem(int  index,ArticleData itemData) {
    if(index == 0){
      return Container(
        child: homeBanner,
      );
    }
    index -=1;
    return ArticleItem(itemData);
  }
}
