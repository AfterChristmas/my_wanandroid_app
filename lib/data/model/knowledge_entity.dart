import 'package:my_wanandroid_app/generated/json/base/json_convert_content.dart';

class KnowledgeEntity with JsonConvert<KnowledgeEntity> {
	List<Knowledgechild> children;
	double courseId;
	double id;
	String name;
	double order;
	double parentChapterId;
	bool userControlSetTop;
	double visible;
}

class Knowledgechild with JsonConvert<Knowledgechild> {
	List<dynamic> children;
	double courseId;
	double id;
	String name;
	double order;
	double parentChapterId;
	bool userControlSetTop;
	double visible;
}
