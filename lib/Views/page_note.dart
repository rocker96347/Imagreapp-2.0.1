import 'package:flutter/material.dart';
import 'package:imgreat_phone_app/Classes/const.dart';
import 'package:imgreat_phone_app/Classes/note.dart';
import 'package:imgreat_phone_app/Utils/db_halper.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'page_addnote.dart';
import 'page_settings.dart';

class PageNote extends StatefulWidget {
  String _title;
  Note note;

  PageNote(this._title, {this.note});

  @override
  _PageNoteState createState() => _PageNoteState();
}

class _PageNoteState extends State<PageNote>
    with AutomaticKeepAliveClientMixin {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";
  String text = "";
  double width;
  double height;
  bool _isChange = false;
  String _note = "";
  final DatabaseHelper helper = DatabaseHelper();

//*********初始狀態(一進到頁面就運行)*******//
  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
    print("note page");
  }

//*********語音辨識 voice to text*******//
  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = text + speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  bool get wantKeepAlive => true;

//*********結束狀態(一離開頁面就運行)*******//
  @override
  dispose() {
    super.dispose();
    // routeObserver.unsubscribe(this);
    _speechRecognition
        .stop()
        .then((result) => setState(() => _isListening = false));
  }

  _listenSpeech() async {
    if (_isAvailable && _isListening) {
      _speechRecognition
          .stop()
          .then((result) => setState(() => _isListening = false));
    } else {
      _speechRecognition.listen(locale: "en_US").then((result) {
        print('$result');
        if (resultText.isNotEmpty) {
          text = resultText + "\n";
        }
      });
    }
  }

  _saveNote() {
    if (_note != null) {
      widget.note.note = _note + "\n" + resultText;
      helper.updateNote(widget.note);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    databaseHelper.initlizeDatabase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colornote,
        leading: IconButton(
          icon: Icon(Icons.build),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PageSetting()));
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNote()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text(widget._title),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: databaseHelper.getNoteList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: Text('Loading'));
                      } else {
                        if (snapshot.data.length < 1) {
                          return Center(
                            child: Text('No Notes, Create New one'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: 80.0,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, bottom: 3.0),
                                      child: Text(
                                        snapshot.data[i].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Microsoft-JhengHei'),
                                      ),
                                    ),
                                    subtitle: Container(
                                      height: 43.5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 7.0,
                                          bottom: 0.0,
                                        ),
                                        child: Text(snapshot.data[i].note,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily:
                                                    'Microsoft-JhengHei')),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isChange = true;
                                          _listenSpeech();
                                          _note = snapshot.data[i].note;
                                          widget.note = snapshot.data[i];
                                        });
                                      },
                                      icon: Icon(Icons.mic),
                                    ),
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                          builder: (context) => AddNote(
                                                note: snapshot.data[i],
                                              ));
                                      Navigator.push(context, route);
                                    },
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).accentColor,
                                  height: 7.0, //分隔線距離
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          if (_isChange == true)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isChange = false;
                  _saveNote();
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                    Container(
                      width: width * 0.77,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                        horizontal: width * 0.05,
                      ),
                      child: Text(_note + "\n" + resultText),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
