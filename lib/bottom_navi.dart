import 'package:flutter/material.dart';
import 'package:imgreat_phone_app/Classes/chatPageView.dart';
import 'package:imgreat_phone_app/Views/page_chatLogin.dart';
import 'Classes/const.dart';
import 'Views/page_fitness.dart';
import 'Views/page_note.dart';

class BottomNavigationBarDemo extends StatefulWidget {
  BottomNavigationBarDemo({Key key, this.selectedIndex}) : super(key: key);

  int selectedIndex;

  @override
  _BottomNavigationBarDemoState createState() =>
      _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  PageController pageController;
  // int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }

  void onPageChanged(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  List<Widget> _bottomNavPages = List(); // 導航欄List

  @override
  void initState() {
    super.initState();
    _bottomNavPages
      // ..add(ChatPageView())
      ..add(LoginScreen(title: 'CHAT'))
      ..add(PageNote('NOTE'))
      ..add(PageFitness());
    pageController = PageController(
      initialPage: widget.selectedIndex,
    );
    print("bottom navigation");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _bottomNavPages,
        // physics: NeverScrollableScrollPhysics(), // 禁止左右滑動換頁
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('CHAT'),
              backgroundColor: colorchat), // Chat 導航欄
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('NOTE'),
              backgroundColor: colornote), // Note 導航欄
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              title: Text('FITNESS'),
              backgroundColor: colorfitness), // Fitness 導航欄
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
