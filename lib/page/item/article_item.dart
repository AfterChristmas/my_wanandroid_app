import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/common/app_colors.dart';
import 'package:my_wanandroid_app/constant/routes.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/data/model/article_entity.dart';
import 'package:my_wanandroid_app/page/webview/route_web_page_data.dart';
import 'package:my_wanandroid_app/util/tool_utils.dart';

class ArticleItem extends StatefulWidget {
  final ArticleData itemData;
  final bool isHomeShow;
  final bool isClickUser;
  final bool isMyFavoritePage;

  ArticleItem(this.itemData,
      {Key key,
        this.isHomeShow = true,
        this.isClickUser = true,
        this.isMyFavoritePage = false})
      : super(key: key);

  @override
  _ArticleItemState createState() {
    return _ArticleItemState();
  }
}

class _ArticleItemState extends State<ArticleItem> {
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
    List<Widget> rightWidgetList = [];
    rightWidgetList.add(Text(
      ToolUtils.signToStr(widget.itemData.title),
      style: TextStyle(
          color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ));
    var tagsList = _buildMiddleTags();
    if (tagsList != null) {
      rightWidgetList.add(tagsList);
    }
    rightWidgetList.add(_buildBottomInfo());
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: Center(
                child: IconButton(
                  icon: Icon(ToolUtils.getNotNullBool(widget.itemData.collect)
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: ToolUtils.getNotNullBool(widget.itemData.collect)
                      ? Colors.deepOrange
                      : Colors.grey,
                  onPressed: _collect,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rightWidgetList,
              ),
            )
          ],
        ),
        onTap: _onClickArticleItem,
      ),
    );
  }

  _buildMiddleTags() {
    List<Widget> tagList = [];
    if (1 == widget.itemData.type) {
      tagList.add(ToolUtils.buildStrokeTagWidget("置顶", Colors.redAccent));
    }
    if (widget.itemData.fresh != null && widget.itemData.fresh) {
      tagList.add(ToolUtils.buildStrokeTagWidget("新", Colors.redAccent));
    }
    if (widget.itemData.tags != null && widget.itemData.tags.length > 0) {
      tagList.addAll(widget.itemData.tags
          .map((e) => ToolUtils.buildStrokeTagWidget(e.name, Colors.green))
          .toList());
    }
    if (tagList.length > 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0.0),
        child: Row(
          children: tagList,
        ),
      );
    } else {
      return Container(
        height: 18,
      );
    }
  }

  Widget _buildBottomInfo() {
    List<Widget> infoList = [];
    var itemData = widget.itemData;
    infoList.add(Icon(
      itemData.audit == "" ? Icons.folder_shared : Icons.person,
      color: AppColors.colorPrimary,
      size: 20.0,
    ));
    infoList.add(GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 6.0),
        child: Text(
          ToolUtils.isNullOrEmpty(itemData.author)
              ? ToolUtils.getNotEmptyStr(itemData.shareUser)
              : itemData.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: widget.isClickUser ? Colors.blue : Colors.black54,
              fontSize: 10.0),
        ),
      ),
//      onTap: ,
    ));

    infoList.add(Expanded(
      child: Text(
        "时间" + ToolUtils.getFirstDate(itemData.niceDate),
        style: TextStyle(
          color: Colors.black,
          fontSize: 10.0,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ));

    infoList.add(Padding(
      padding: EdgeInsets.only(right: 10),
      child: Text(
        ToolUtils.getNotEmptyStr(itemData.superChapterName +
            "/" +
            ToolUtils.getNotEmptyStr(itemData.chapterName)),
        maxLines: 1,
        style: TextStyle(
            color: widget.isHomeShow ? Colors.blue : Colors.black54,
            fontSize: 10.0,
            decoration: TextDecoration.none),
      ),
    ));

    return Row(
      children: infoList,
    );
  }

  ///文章 item 点击事件
  void _onClickArticleItem() {
    RouteWebPageData pageData = new RouteWebPageData(
        id: widget.itemData.id,
        title: widget.itemData.title,
        url: widget.itemData.link,
        collect: widget.itemData.collect);
    Navigator.pushNamed(context, Routes.webViewPage, arguments: pageData);
  }
  ///文章 item 点击事件
  Future<void> _collect() async {
    bool isLogin = await dataUtils.isLogin();
    if(!isLogin){
      Navigator.pushNamed(context, Routes.loginPage);
      return;
    }
    if (ToolUtils.getNotNullBool(widget.itemData.collect)) {
      if (widget.isMyFavoritePage) {
        await dataUtils.cancelCollectArticleForMyFavoritePage(
            widget.itemData.id,
            widget.itemData.originId == null ? "-1" : widget.itemData.originId);
      } else {
        await dataUtils.cancelCollectArticle(widget.itemData.id);
        setState(() {
          widget.itemData.collect = false;
        });
        ToolUtils.showToast(msg: "取消收藏成功");
      }
    } else {
      await dataUtils.collectArticle(widget.itemData.id);
      setState(() {
        widget.itemData.collect = true;
      });
      ToolUtils.showToast(msg: "收藏成功");
    }
  }
}
