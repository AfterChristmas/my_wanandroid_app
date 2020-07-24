class Api {
  static const String BASE_URL = "https://www.wanandroid.com/";
  static const String BANNER = "banner/json";
  //置顶文章
  static const String ARTICLE_TO_LIST = "article/top/json";


  //首页文章列表 http://www.wanandroid.com/article/list/0/json
  // 知识体系下的文章http://www.wanandroid.com/article/list/0/json?cid=60
  static const String ARTICLE_LIST = "article/list/";
  //登录
  static const String LOGIN = "user/login";

  //收藏 站内文章
  static const String COLLECT_ARTICLE = "lg/collect/%s/json";

  //取消收藏文章
  static const String CANCEL_COLLECT_ARTICLE = "lg/uncollect_originId/%s/json";
  //取消收藏文章  我的收藏页
  static const String CANCEL_COLLECT_ARTICLE_FOR_MY_FAV = "lg/uncollect/%s/json";
  //知识体系
  static const String KNOWLEDGE_SYSTEM = "/tree/json";
}
