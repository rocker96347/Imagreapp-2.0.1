import 'package:flutter/material.dart';

class PageFitness extends StatefulWidget {
  Color _color;

  PageFitness(this._color);

  @override
  _PageFitnessState createState() => _PageFitnessState();
}

class _PageFitnessState extends State<PageFitness>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print("fitness page");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Center(
                      child: Image.asset(
                    'assets/images/fitness.jpg',
                    fit: BoxFit.fill,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
