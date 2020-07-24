import 'package:my_wanandroid_app/generated/json/base/json_convert_content.dart';

class LoginDataEntity with JsonConvert<LoginDataEntity> {
	bool admin;
	List<dynamic> chapterTops;
	int coinCount;
	List<int> collectIds;
	String email;
	String icon;
	int id;
	String nickname;
	String password;
	String publicName;
	String token;
	int type;
	String username;
}
