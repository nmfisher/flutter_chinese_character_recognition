import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:chinese_character_recognition/chinese_character_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ChineseCharacterRecognition _plugin;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _plugin = ChineseCharacterRecognition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children:[
            RaisedButton(
              child: Text("CLICK ME"),
              onPressed: () {
                _plugin.recognize([[Offset(0,1), Offset(1,2), Offset(10,20), Offset(50,70)], ]);
              },),
            Expanded(child:StreamBuilder(
              stream:_plugin.candidates,
              builder:(BuildContext ctx, AsyncSnapshot<List<String>> candidates) {
                if(candidates.data == null)
                  return Text("No candidates");
              return ListView(children: candidates.data.map((x) => Text(x)).toList());
              }
          )),]
      ),
    )));
  }
}
