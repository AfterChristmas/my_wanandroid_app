import 'package:flutter/cupertino.dart';
import 'package:my_wanandroid_app/common/application.dart';
import 'package:my_wanandroid_app/constant/api.dart';
import 'package:my_wanandroid_app/constant/constants.dart';
import 'package:my_wanandroid_app/data/http_util.dart';
import 'package:my_wanandroid_app/data/model/article_entity.dart';
import 'package:my_wanandroid_app/data/model/knowledge_entity.dart';
import 'package:my_wanandroid_app/data/model/login_data_entity.dart';
import 'package:my_wanandroid_app/util/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';

import 'model/banner_data.dart';

DataUtils dataUtils = DataUtils();

class DataUtils {
  DataUtils._internal();

  static DataUtils _singleton = new DataUtils._internal();

  factory DataUtils() => _singleton;

  //获取登录的用户名
  Future<String> getUserName() async {
    return await spUtil.getString(SharedPreferencesKeys.LOGIN_USERNAME_KEY);
  }

  Future<void> setUserName(String userName) async {
    return await spUtil.putString(
        SharedPreferencesKeys.LOGIN_USERNAME_KEY, userName);
  }

  //设置登录状态
  Future<void> setLoginState(bool isLogin) async {
    return await spUtil.putBool(SharedPreferencesKeys.LOGIN_STATE_KEY, isLogin);
  }

  //设置登录状态
  Future<void> setLoginUserName(String username) async {
    return await spUtil.putString(
        SharedPreferencesKeys.LOGIN_USERNAME_KEY, username);
  }

  //判断登录状态
  Future<bool> isLogin() async {
    return await spUtil.getBool(SharedPreferencesKeys.LOGIN_STATE_KEY);
  }

  //清除用户信息
  Future<bool> clearUserName() async {
    return await spUtil.remove(SharedPreferencesKeys.LOGIN_USERNAME_KEY);
  }

  //首页数据模块
  Future<List<BannerData>> getBannerData() async {
    List datas = await httpUtils.get(Api.BANNER);
    return datas == null
        ? null
        : datas.map((item) => BannerData.fromJson(item)).toList();
  }

  //获取首页置顶文章数据
  Future<List<ArticleData>> getTopArticleData() async {
    List datas = await httpUtils.get(Api.ARTICLE_TO_LIST);
    return datas == null
        ? null
        : datas.map((item) => ArticleData().fromJson(item)).toList();
  }

  ///首页数据模块
  //获取首页最新文章数据
  Future<ArticleEntity> getArticleData(int pageIndex) async {
    //首先从服务端获取最外层的json数据的data
    var datas = await httpUtils.get(Api.ARTICLE_LIST + "$pageIndex/json");
    return datas == null ? null : ArticleEntity().fromJson(datas);
  }

  //登录
  Future<LoginDataEntity> login(
      String username, String password, BuildContext context) async {
    FormData formData =
        FormData.fromMap({"username": username, "password": password});
    //首先从服务端获取最外层的json数据的data
    var datas = await httpUtils.post(Api.LOGIN,
        formData: formData,
        isAddLoading: true,
        context: context,
        loadingText: "正在登录");
    if (datas != null) {
      Application.isLogin = true;
    }
    return datas == null ? null : LoginDataEntity().fromJson(datas);
  }

  //收藏文章
  Future collectArticle(int articleId) async {
    //首先从服务端获取最外层的json数据的data
    var datas = await httpUtils.post(sprintf(Api.COLLECT_ARTICLE, [articleId]));
    return datas;
  }

  //取消收藏
  Future cancelCollectArticle(int articleId) async {
    //首先从服务端获取最外层的json数据的data
    var datas =
        await httpUtils.post(sprintf(Api.CANCEL_COLLECT_ARTICLE, [articleId]));
    return datas;
  }

  //取消收藏
  Future cancelCollectArticleForMyFavoritePage(
      int articleId, String originId) async {
    //首先从服务端获取最外层的json数据的data
    FormData formData = FormData.fromMap({"originId": originId});
    var datas = await httpUtils.post(
        sprintf(Api.CANCEL_COLLECT_ARTICLE_FOR_MY_FAV, [articleId]),
        formData: formData);
    return datas;
  }

  //知识体系
  Future<List<KnowledgeEntity>> getKnowledgeSystem() async {
    //首先从服务端获取最外层的json数据的data
    List datas = await httpUtils.get(Api.KNOWLEDGE_SYSTEM);
    return datas == null
        ? null
        : datas.map((e) => KnowledgeEntity().fromJson(e)).toList();
  }
}
