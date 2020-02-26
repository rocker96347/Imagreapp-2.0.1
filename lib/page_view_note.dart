import 'package:flutter/material.dart';

import 'Views/page_addnote.dart';
import 'Views/page_note.dart';

class PageViewNote extends StatefulWidget {
  String _title;
  Color _color;
  PageViewNote(this._title, this._color);
  @override
  State<StatefulWidget> createState() {
    return PageViewNoteState();
  }
}

class PageViewNoteState extends State<PageViewNote> {
  PageController pagecontroller;
  int currentindex = 0;

  void onPageChanged(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    pagecontroller = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pagecontroller,
          onPageChanged: onPageChanged,
          children: [
            PageNote(widget._title, widget._color),
            AddNote(),
          ],
          physics: NeverScrollableScrollPhysics()), // 禁止滑動

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentindex == 0) {
            pagecontroller.animateTo(MediaQuery.of(context).size.width,
                duration: new Duration(seconds: 1), curve: Curves.easeIn);
          } else {
            pagecontroller.animateTo(0.0,
                duration: new Duration(seconds: 1), curve: Curves.easeIn);
          }
        },
        child: Icon(Icons.add),
        elevation: 10.0,
      ),
    );
  }
}
