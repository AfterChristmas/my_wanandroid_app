import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_wanandroid_app/common/app_colors.dart';
import 'package:my_wanandroid_app/data/data_utils.dart';
import 'package:my_wanandroid_app/data/model/knowledge_entity.dart';

class KnowSystemTreePage extends StatefulWidget {
  KnowSystemTreePage({Key key}) : super(key: key);

  @override
  _KnowSystemTreePageState createState() {
    return _KnowSystemTreePageState();
  }
}

class _KnowSystemTreePageState extends State<KnowSystemTreePage>
    with AutomaticKeepAliveClientMixin {
  List<KnowledgeEntity> knowledgeEntityList = [];

  @override
  void initState() {
    super.initState();
    loadKnowledgeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildTreeItems(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void loadKnowledgeData() async {
    await dataUtils.getKnowledgeSystem().then((list) => {
          if (list == null || list.length == 0)
            {}
          else
            {
              if (mounted)
                {
                  setState(() {
                    knowledgeEntityList = list;
                  })
                }
            }
        });
  }

  buildTreeItems() {
    if (knowledgeEntityList == null || knowledgeEntityList.length == 0) {
      return [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitCubeGrid(
                  size: 55,
                  color: AppColors.colorPrimary,
                  duration: Duration(microseconds: 800),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '正在加载...',
                    style: TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                )
              ],
            ),
          ),
        )
      ];
    } else {
      List<Widget> widgets = [];
      for (KnowledgeEntity knowledgeEntity in knowledgeEntityList) {
        //分组的标题
        widgets.add(Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            knowledgeEntity.name,
            style: TextStyle(color: AppColors.colorPrimary, fontSize: 18.0),
          ),
        ));

        widgets.add(Padding(
          padding: EdgeInsets.only(left: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: buildTreeChildItems(knowledgeEntity.children),
          ),
        ));
      }
      return widgets;
    }
  }

  buildTreeChildItems(List<Knowledgechild> childrenList) {
    List<Widget> widgets = [];
    if (childrenList != null && childrenList.length > 0) {
      for (Knowledgechild knowledgechild in childrenList) {
        ActionChip actionChip = getActionChip(knowledgechild);
        widgets.add(actionChip);
      }
    }
    return widgets;
  }

  ActionChip getActionChip(Knowledgechild knowledgechild) {
    return ActionChip(
      backgroundColor: Colors.blue,
      label: Text(
        knowledgechild.name,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    );
  }
}
