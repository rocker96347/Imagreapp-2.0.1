import 'package:flutter/material.dart';

class PageSetting extends StatefulWidget {
  @override
  _PageSettingState createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  @override
  void initState() {
    super.initState();
    print("setting page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('setting list'),
      ),
    );
  }
}
