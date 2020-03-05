import 'package:flutter/material.dart';
import 'package:imgreat_phone_app/Views/chat.dart';
import 'package:imgreat_phone_app/Views/page_chatmain.dart';
import 'package:imgreat_phone_app/Views/page_login.dart';

class _TabData {
  final Widget tab;
  final Widget body;
  _TabData({this.tab, this.body});
}

final _tabDataList = <_TabData>[
  _TabData(tab: Text('登入'), body: LoginScreen(title: 'CHAT')),
  _TabData(tab: Text('主畫面'), body: ChatMainScreen()),
  _TabData(tab: Text('聊天室'), body: Chat())
];

class ChatPageView extends StatefulWidget {
  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  final tabBarList = _tabDataList.map((item) => item.tab).toList();
  final tabBarViewList = _tabDataList.map((item) => item.body).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabBarList.length,
        child: Column(
          children: <Widget>[
            Expanded(
                child: TabBarView(
              children: tabBarViewList,
              physics: NeverScrollableScrollPhysics(), // 禁止滑动
            ))
          ],
        ));
  }
}
