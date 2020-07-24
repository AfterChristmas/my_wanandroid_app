import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/common/app_colors.dart';
import 'package:my_wanandroid_app/common/application.dart';
import 'package:my_wanandroid_app/constant/routes.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/page/login/login_event.dart';
import 'package:my_wanandroid_app/util/log_util.dart';
import 'package:my_wanandroid_app/util/tool_utils.dart';

class MyInfoPage extends StatefulWidget {
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() {
    return _MyInfoPageState();
  }
}

class _MyInfoPageState extends State<MyInfoPage> {
  String userName;

  @override
  void initState() {
    super.initState();
    getUserName();
    Application.eventBus.on<LoginEvent>().listen((event) {
      if (mounted) {
        setState(() {
          userName = event.username;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildListChild(),
    );
  }

  void getUserName() async {
    await dataUtils.getUserName().then((value) => {
          setState(() {
            userName = value;
          })
        });
  }

  List<Widget> _buildListChild() {
    return [
      buildAvatar(),
      buildLoginBtn(),
      buildMyCollect(),
      buildEveryDayQuestion(),
      //清楚缓存
      buildClearCache(),
      //关于作者
      buildAboutUs(),
      //退出登录
      buildLoginOut(),
    ];
  }

  Widget buildAvatar() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: 100,
        height: 100,
        child: CircleAvatar(
          backgroundImage: AssetImage(
            Application.isLogin
                ? ToolUtils.getImage("ic_launcher_foreground")
                : ToolUtils.getImage("ic_default_avatar", format: "webp"),
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return RaisedButton(
      color: AppColors.colorPrimary,
      child: Text(
        (userName == null || userName == "") ? "请登录" : userName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (!Application.isLogin) {
          Navigator.pushNamed(context, Routes.loginPage);
        }
      },
    );
  }

  Widget buildMyCollect() {
    return buildCommonItem(Icons.favorite, "我的收藏", () {
      if (Application.isLogin) {
        // todo
      } else {
        // todo
      }
    });
  }

  Widget buildEveryDayQuestion() {
    return buildCommonItem(Icons.question_answer, "每日一问", () {
      if (Application.isLogin) {
        // todo
      } else {
        // todo
      }
    });
  }

  Widget buildClearCache() {
    return buildCommonItem(Icons.clear, "清楚缓存", () {
      ToolUtils.showAlertDialog(context, "确定清楚缓存么？", confirmText: "确定",
          confirmCallback: () {
        ToolUtils.clearCookie();
        ToolUtils.showToast(msg: "清除成功");
      });
    });
  }
  Widget buildAboutUs() {
    return buildCommonItem(Icons.supervised_user_circle, "关于我们", () {
      LogUtil.d("跳转到关于我们");
      //todo
    });
  }
  Widget buildLoginOut() {
    return buildCommonItem(Icons.exit_to_app, "退出登录", () {
      LogUtil.d("退出登录");
      ToolUtils.showAlertDialog(context, "确定退出登录么？",confirmText: "确定",confirmCallback: (){
        ToolUtils.clearCookie();
        loginOut();
        setState(() {
          Application.isLogin = false;
          dataUtils.setLoginState(false);
          dataUtils.clearUserName();
          userName = null;
          ToolUtils.showToast(msg: "退出登录成功");
        });
      });
    });
  }

  Widget buildCommonItem(
      IconData iconData, String itemContent, Function clickListener) {
    return InkWell(
      child: Padding(
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  itemContent,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
      onTap: clickListener,
    );
  }

  void loginOut() {
  }
}
