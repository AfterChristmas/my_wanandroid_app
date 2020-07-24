import 'package:flutter/material.dart';
import 'package:my_wanandroid_app/common/app_colors.dart';
import 'package:my_wanandroid_app/common/application.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/data/model/login_data_entity.dart';
import 'package:my_wanandroid_app/page/login/login_event.dart';
import 'package:my_wanandroid_app/util/tool_utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool isShowPassWord = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if(Application.isDebug){
      _nameController.text = "xxxxxxx415456465465";
      _pwdController.text = "xxxxxxx";
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToolUtils.getCommonAppBar(context, "登录"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.colorPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                elevation: 10.0,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5.0,
                    left: 10.0,
                    right: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular((10.0)))),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.asset("images/ic_launcher.png",fit: BoxFit.cover,),
                        ),
                        buildSignInTextForm(),
                        SizedBox(height: 15,),
                        buildBottomBtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildSignInTextForm() {
    return Column(
      children: <Widget>[
        TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            hintText: "WanAndroid 用户名你",
            labelText: "用户名",
            border: UnderlineInputBorder()
          ),
          controller: _nameController,
          validator: (username){
            if(username == null || username.isEmpty){
              return "用户名不能为空";
            }
            return null ;
          },
        ),
        TextFormField(
          autofocus: false,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !isShowPassWord,
          controller: _pwdController,
          decoration: InputDecoration(
            icon: Icon(Icons.lock,color: Colors.black,),
            hintText: "WanAndroid 登录密码",
            labelText: "密码",
            border: UnderlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye,color: Colors.black,),
              onPressed: showPassword,
            )
          ),
        )
      ],
    );
  }

  buildBottomBtn() {
    return Row(
      children: <Widget>[
        SizedBox(width: 15.0,),
        Expanded(
          child: RaisedButton(
            child: Text("登录"),
            color: AppColors.colorPrimary,
            onPressed: login,
          ),
        ),
        SizedBox(width: 30.0,),
        Expanded(
          child: RaisedButton(
            child: Text("注册"),
            color: AppColors.colorPrimary,
            onPressed: register,
          ),
        ),
        SizedBox(width: 15.0,),
      ],
    );
  }

  showPassword() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  login() async{
    if(!validInput()){
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    LoginDataEntity loginDataEntity = await dataUtils.login(_nameController.text, _pwdController.text, context);
    if(loginDataEntity ==  null || loginDataEntity.username == null  || loginDataEntity.username==""){

    }else{
      await dataUtils.setLoginState(true);
      await dataUtils.setLoginUserName(loginDataEntity.username);
      Application.eventBus.fire(LoginEvent(loginDataEntity.username));
      ToolUtils.showToast(msg: "登录成功");
      Navigator.of(context).pop();
    }
  }

  register() {}

  bool validInput(){
    if (_nameController.text == null || _nameController.text == "") {
      ToolUtils.showToast(msg: "用户名儿得填一个吧");
      return false;
    }
    if (_pwdController.text == null || _pwdController.text == "") {
      ToolUtils.showToast(msg: "密码得填一个吧");
      return false;
    }
    if (_pwdController.text.length < 6) {
      ToolUtils.showToast(msg: "密码长度太短了吧,兄嘚");
      return false;
    }
    return true;
  }
}
