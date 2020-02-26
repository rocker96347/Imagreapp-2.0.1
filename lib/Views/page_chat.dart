import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imgreat_phone_app/Classes/customButton.dart';
import 'package:imgreat_phone_app/Classes/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageChat extends StatefulWidget {
  final String user;
  final Color color;
  final String title;

  PageChat(this.title, this.color, {Key key, this.user}) : super(key: key);

  @override
  _PageChatState createState() => _PageChatState();
}

class _PageChatState extends State<PageChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final String userNameKey = "usernamekey";
  String myuser = "A";
  bool _logIn = false;

  TextEditingController messageController = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  ScrollController scrollController = new ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      _firestore.collection('messages').add({
        'text': messageController.text,
        'from': myuser,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        .0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    print("Chat page");
    print(_logIn);
    if (myuser != "A") {
      setState(() {
        _logIn = true;
      });
      print("歡迎!" + myuser);
    } else {
      print("請登入!");
    }
    print(myuser);
  }

  @override
  void dispose() {
    scrollController.dispose(); //为了避免内存泄露，需要调用scrollController.dispose
    super.dispose();
    print("下次見!" + myuser);
  }

  Future _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myuser = (prefs.getString(userNameKey));
    });
  }

  Future _userSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(userNameKey, myuser);

      if (myuser != "A") {
        setState(() {
          _logIn = true;
          print("歡迎!" + myuser);
        });
      }
    });
  }

  Future _userSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (myuser != "A") {
        setState(() {
          _logIn = false;
          print(myuser + "登出!");
          myuser = "A";
          prefs.setString(userNameKey, myuser);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: Icon(Icons.chat),
            // Image.asset("assets/icons/ic_launcher.png"),
          ),
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.directions_run),
            onPressed: () {
              _userSignOut();
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: SafeArea(
            child: !_logIn
                ? Column(
                    //登入畫面
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                            tag: 'logo',
                            child: Container(
                              width: 100.0,
                              child: Image.asset("assets/images/logo.png"),
                            ),
                          ),
                          Text(
                            "IMG Chat",
                            style: TextStyle(
                              fontSize: 40.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      new Text("Please enter username:"),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: new TextField(
                              controller: usercontroller,
                              maxLength: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      CustomButton(
                        text: "Enter",
                        callback: () {
                          myuser = usercontroller.text;
                          _userSignIn();
                        },
                      )
                    ],
                  )
                : Column(
                    //聊天介面
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('messages')
                              .orderBy('date',
                                  descending:
                                      true //descending降序 讓聊天紀錄按時程降序排列  最新紀錄在ListView最上面
                                  )
                              // .limit(20) //僅顯示lateset的20則消息
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              List<DocumentSnapshot> docs =
                                  snapshot.data.documents;

                              List<Widget> messages = docs
                                  .map((doc) => Message(
                                        from: doc.data['from'],
                                        text: doc.data['text'],
                                        me: myuser == doc.data['from'],
                                      ))
                                  .toList();

                              return ListView(
                                reverse: true, //使ListView Widget 上下顛倒
                                controller: scrollController,
                                children: <Widget>[
                                  ...messages,
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        //底層輸入區
                        height: 45.0,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              //打字欄位圖框
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: TextField(
                                  onSubmitted: (value) => callback(),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    hintText: "Enter a Message...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  controller: messageController,
                                ),
                              ),
                            ),
                            IconButton(
                              //傳送按鈕
                              color: Colors.blueGrey[700],
                              icon: Icon(Icons.send),
                              iconSize: 25.0,
                              onPressed: () {
                                callback();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          //返回頁面底部按鈕
          mini: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)), //按鈕形狀
          ),
          backgroundColor: widget.color, //按鈕背景顏色
          child: Icon(Icons.arrow_downward), //按鈕圖標
          onPressed: () {
            scrollController.animateTo(.0,
                duration: Duration(milliseconds: 700),
                curve: Curves.ease); //按鈕效果
          }),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartTop, //按鈕位置
    );
  }
}
