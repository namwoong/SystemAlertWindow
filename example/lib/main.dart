import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _requestPermissions();
    SystemAlertWindow.registerOnClickListener(callBack);

    _showOverlayWindow();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SystemAlertWindow.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow() {
      SystemWindowHeader header = SystemWindowHeader(
          title: SystemWindowText(text: "ⓒ Code Play Corp.", fontSize: 8, textColor: Colors.black45),
          padding: SystemWindowPadding(left: 12, right: 0, bottom: 0, top: 0), //SystemWindowPadding.setSymmetricPadding(12, 12),
          //subTitle: SystemWindowText(text: "9898989899", fontSize: 14, fontWeight: FontWeight.BOLD, textColor: Colors.black87),
          decoration: SystemWindowDecoration(startColor: Colors.transparent),
      );
      SystemWindowFooter footer = SystemWindowFooter(
          buttons: [
            SystemWindowButton(
              text: SystemWindowText(text: "move to grab tags", fontSize: 10, textColor: Color.fromRGBO(250, 139, 97, 1)),
              tag: "grab",
              //padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
              width: SystemWindowButton.MATCH_PARENT,
              height: 30,
              decoration: SystemWindowDecoration(startColor: Colors.white.withOpacity(0.2), endColor: Colors.white.withOpacity(0.2), borderWidth: 0, borderRadius: 30.0),
            ),
            SystemWindowButton(
              text: SystemWindowText(text: "close", fontSize: 10, textColor: Colors.white),
              tag: "close",
              //padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
              width: SystemWindowButton.WRAP_CONTENT,
              height: 30, //SystemWindowButton.WRAP_CONTENT,
              decoration: SystemWindowDecoration(
                  startColor: Color.fromRGBO(250, 139, 97, 1).withOpacity(0.2), endColor: Color.fromRGBO(247, 28, 88, 1).withOpacity(0.2), borderWidth: 0, borderRadius: 30.0),
            )
          ],
          padding: SystemWindowPadding(left: 16, right: 16, bottom: 12),
          //decoration: SystemWindowDecoration(startColor: Colors.white),
          buttonsPosition: ButtonPosition.CENTER);


          SystemAlertWindow.showSystemWindow(
              height: 50,
              header: header,
              footer: footer,
              margin: SystemWindowMargin(left: 8, right: 8, top: 1200, bottom: 0),
              gravity: SystemWindowGravity.TOP,
              notificationTitle: "Incoming Call",
              notificationBody: "+1 646 980 4741",
              prefMode: prefMode
          );
          MoveToBackground.moveTaskToBack();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('System Alert Window Example App'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MaterialButton(
                  onPressed: _showOverlayWindow,
                  textColor: Colors.white,
                  child: Text("Copy"),
                  color: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




///
/// Whenever a button is clicked, this method will be invoked with a tag (As tag is unique for every button, it helps in identifying the button).
/// You can check for the tag value and perform the relevant action for the button click
///
Future<void> callBack(String tag) async {
  print(tag);
  switch (tag) {
    case "grab":
      //SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
      Bringtoforeground.bringAppToForeground();
      break;
    case "close":
      SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
      break;

    default:
      print("OnClick event of $tag");
  }
}
