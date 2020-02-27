import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const ChatMessage({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(from,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
              )),
          Material(
            color: me ? Colors.cyan : Colors.grey[350],
            borderRadius: BorderRadius.circular(18.0),
            elevation: 0.0,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
                child: Text(
                  text,
                )),
          )
        ],
      ),
    );
  }
}