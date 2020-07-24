import 'package:my_wanandroid_app/generated/json/base/json_convert_content.dart';

class ArticleEntity with JsonConvert<ArticleEntity> {
	int curPage;
	List<ArticleData> datas;
	int offset;
	bool over;
	int pageCount;
	int size;
	int total;
}

class ArticleData with JsonConvert<ArticleData> {
	String apkLink;
	int audit;
	String author;
	bool canEdit;
	int chapterId;
	String chapterName;
	bool collect;
	int courseId;
	String desc;
	String descMd;
	String envelopePic;
	bool fresh;
	int id;
	String link;
	String niceDate;
	String niceShareDate;
	String origin;
	String originId;
	String prefix;
	String projectLink;
	int publishTime;
	int realSuperChapterId;
	int selfVisible;
	int shareDate;
	String shareUser;
	int superChapterId;
	String superChapterName;
	List<ArticleDatasTag> tags;
	String title;
	int type;
	int userId;
	int visible;
	int zan;
}

class ArticleDatasTag with JsonConvert<ArticleDatasTag> {
	String name;
	String url;
}
