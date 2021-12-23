import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';
import 'package:provider/provider.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:system_alert_window_example/provider/user_provider.dart';

import 'ui/screens/home_page.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    SystemAlertWindow.registerOnClickListener(callBack);


    screenListener.addScreenShotListener((filePath) {
      setState(() async {
        Directory directory = Directory('/storage/emulated/0/DCIM/Screenshots');
        FileSystemEntity fileSystemEntity = directory.listSync().last;

        //ImageGallerySaver.saveFile(fileSystemEntity.path);

        final inputImage = InputImage.fromFilePath(fileSystemEntity.path);
        RecognisedText recognisedText = await _textDetector.processImage(inputImage);

        Bringtoforeground.bringAppToForeground();
      });
    });
    screenListener.watch();

    _showOverlayWindow();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 759),
      builder: () => MaterialApp(
        title: 'Searchable ListView',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900,
          primarySwatch: Colors.grey,
        ),
        home: const HomePage(),
      ),
    );
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
