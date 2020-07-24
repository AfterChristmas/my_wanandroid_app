import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:my_wanandroid_app/constant/api.dart';
import 'package:my_wanandroid_app/util/log_util.dart';
import 'package:my_wanandroid_app/util/tool_utils.dart';
import 'package:path_provider/path_provider.dart';

HttpUtils httpUtils = HttpUtils();

class HttpUtils {
  HttpUtils._internal() {
    if (null == _dio) {
      _dio = Dio();
      _dio.options.baseUrl = Api.BASE_URL;
      _dio.options.connectTimeout = 30 * 1000;
      _dio.options.sendTimeout = 30 * 1000;
      _dio.options.receiveTimeout = 30 * 1000;
    }
  }

  static HttpUtils _singleton = HttpUtils._internal();

  factory HttpUtils() => _singleton;

  Dio _dio;

  Future get(String url,
      {Map<String, dynamic> params,
      bool isAddLoading = false,
      BuildContext context,
      String loadingText}) async {
    Response response;

    Directory applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    String documentsPath = applicationDocumentsDirectory.path;
    //新建目录
    var dir = Directory("$documentsPath/cookies");
    await dir.create();

    //添加cookies
    _dio.interceptors.add(
        CookieManager(PersistCookieJar(dir: dir.path, ignoreExpires: true)));
    if (isAddLoading) {
      ToolUtils.showLoading(context, loadingText);
    }

    try {
      if (params != null) {
        response = await _dio.get(url, queryParameters: params);
      } else {
        response = await _dio.get(url);
      }

      ToolUtils.disMissLoadingDialog(isAddLoading, context);
      if (response.data['errorCode'] == 0) {
        return response.data['data'];
      } else {
        String data = response.data["errorMsg"];
        ToolUtils.showToast(msg: data);
        LogUtil.d("请求网路错误");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        LogUtil.d(e.response.headers.toString());
        LogUtil.d(e.response.request.toString());
      } else {
        LogUtil.d(e.request.toString());
      }
      //ToolUtils.showToast(msg: handleError(e));
      ToolUtils.disMissLoadingDialog(isAddLoading, context);
      return null;
    }
  }

  ///post请求
  ///url : 地址
  ///formData : 请求参数
  Future post(String url,
      {FormData formData,
      Map<String, dynamic> queryParameters,
      bool isAddLoading = false,
      BuildContext context,
      String loadingText}) async {
    Response response;

    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();

    //cookie
    _dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));

    //loading
    if (isAddLoading) {
      ToolUtils.showLoading(context, loadingText);
    }

    try {
      if (formData != null) {
        response = await _dio.post(url, data: formData);
      } else if (queryParameters != null) {
        response = await _dio.post(url, queryParameters: queryParameters);
      } else {
        response = await _dio.post(url);
      }

      //隐藏loading
      ToolUtils.disMissLoadingDialog(isAddLoading, context);

      //json 数据
      //LogUtil.d(response.toString());

      if (response.data['errorCode'] == 0) {
        //这里直接把data部分给搞出来,免得每次在外面去解析˛
        return response.data['data'];
      } else {
        String data = response.data["errorMsg"];
        ToolUtils.showToast(msg: data);
        LogUtil.d("请求网络错误 : $data");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        LogUtil.d(e.response.headers.toString());
        LogUtil.d(e.response.request.toString());
      } else {
        LogUtil.d(e.request.toString());
      }

      //ToolUtils.showToast(msg: handleError(e));
      ToolUtils.disMissLoadingDialog(isAddLoading, context);
      return null;
    }
  }
}
