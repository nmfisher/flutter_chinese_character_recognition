
import 'dart:async';
import 'dart:core';
import 'dart:js';
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

import 'html_recognition_adapter.dart';


class ChineseCharacterRecognitionPlugin {
  
  static MethodChannel _channel;

  static void registerWith(Registrar registrar) {
    _channel = MethodChannel(
      'chinese_character_recognition',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    final ChineseCharacterRecognitionPlugin instance = ChineseCharacterRecognitionPlugin();
    _channel.setMethodCallHandler(instance.handleMethodCall);

  }

  HandwritingRecognizer _recognizer;

  int sort(a, b) {
    return getProperty(b, "score").compareTo(getProperty(a, "score"));
  }

  void _initialize(int numCandidates) {
      _recognizer = HandwritingRecognizer(
            numCandidates,
            allowInterop(() {
              print("Handwriting recognizer initialization complete.");
              _channel.invokeMethod("initialized");
              return 1;
            }),
            allowInterop((dynamic matches) {
              matches.sort(sort);
              var data =
                matches.map((x) => [getProperty(x, "score"), getProperty(x, "hanzi")]).toList();
              _channel.invokeMethod("result", data);
            }),
            allowInterop((error) {
              _channel.invokeMethod("error", error.toString());
            }),
          );
          _recognizer.initialize();
  }

    

  Future<dynamic> handleMethodCall(MethodCall call) async {
    final method = call.method;

    switch (method) {
      case 'initialize':
        _initialize(call.arguments);
        _channel.invokeMethod("initialized");
        break;
      case 'lookup':
        _recognizer.lookup(jsify(call.arguments).toList());
        break;
    }
  }
}
