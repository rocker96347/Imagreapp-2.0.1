import 'package:flutter/material.dart';
import 'bottom_navi.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: new BottomNavigationBarDemo(),
    );
  }
}

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MyAppState();
//   }
// }

// class _MyAppState extends State<MyApp> {
//   String _message = '';

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final Firestore _firestore = Firestore.instance;

//   _register() {
//     _firebaseMessaging.getToken().then((token) => print(token));
//   }

//   @override
//   void initState() {
//     super.initState();
//     getMessage();
//   }

//   void getMessage() {
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//       print('on message $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }

//   _saveDeviceToken() async {
//     // Get the current user
//     String myuser = 'ricky';
//     // FirebaseUser user = await _auth.currentUser();

//     // Get the token for this device
//     String fcmToken = await _firebaseMessaging.getToken();

//     // Save it to Firestore
//     if (fcmToken != null) {
//       var tokens = _firestore
//           .collection('users')
//           .document(myuser)
//           .collection('tokens')
//           .document(fcmToken);

//       await tokens.setData({
//         'token': fcmToken,
//         'date': FieldValue.serverTimestamp(), // optional
//         'platform': Platform.operatingSystem // optional
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text("Message: $_message"),
//                 OutlineButton(
//                   child: Text("Register My Device"),
//                   onPressed: () {
//                     _register();
//                     _saveDeviceToken();
//                   },
//                 ),
//                 // Text("Message: $message")
//               ]),
//         ),
//       ),
//     );
//   }
// }
