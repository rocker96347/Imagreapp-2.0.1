import 'package:flutter/material.dart';
import 'Views/page_chat.dart';
import 'Views/page_fitness.dart';
import 'Views/page_note.dart';

class BottomNavigationBarDemo extends StatefulWidget {
  @override
  _BottomNavigationBarDemoState createState() =>
      _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  int _selectedIndex = 1;
  Color colorchat = Colors.cyan[700];
  Color colornote = Colors.brown;
  Color colorfitness = Colors.orange;
  PageController pageController;

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
      // _selectedIndex = index;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _bottomNavPages = List(); // 導航欄List

  @override
  void initState() {
    super.initState();
    _bottomNavPages
      ..add(PageChat('Chat', colorchat))
      ..add(PageNote('NOTE', colornote))
      ..add(PageFitness(colorfitness));
    pageController = PageController(
      initialPage: 1,
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
      body:
          // IndexedStack(
          //   index: _selectedIndex,
          //   children: _bottomNavPages
          // ),
          PageView(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
