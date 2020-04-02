@JS('flutter_chinese_character_recognition')
library flutter_chinese_character_recognition;

import 'dart:ui';
import 'package:chinese_character_recognition/recognition_adapter.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';

RecognitionAdapter getAdapter(int numCandidates) => HtmlRecognitionAdapter(numCandidates);


@JS()
class HandwritingRecognizer {
  external HandwritingRecognizer(int numCandidates, Function onInit,
      Function onResult, Function onError);
  external void lookup(List strokes);
  external void clear();
  external void initialize();
}

class HtmlRecognitionAdapter extends RecognitionAdapter {

  static const MethodChannel _channel =
      const MethodChannel('chinese_character_recognition');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  HtmlRecognitionAdapter._internal(int numCandidates) : super(numCandidates) {
    _channel.setMethodCallHandler(channelMethodCallHandler);
    initialize();
  }

  factory HtmlRecognitionAdapter(int numCandidates) {
    return HtmlRecognitionAdapter._internal(numCandidates);
  }

  void initialize() async {
    await _channel.invokeMethod('initialize', this.numCandidates);
  }

  void lookup(List<List<Offset>> strokes) {
    if (strokes.length == 0) {
      // the drawing canvas has been reset
      candidatesController.add(null);
      return;
    }

     _channel.invokeMethod(
          "lookup", strokes.map((stroke) => stroke.map((pt) => [pt.dx, pt.dy]).toList()).toList()
    );      
  }

   Future<dynamic> channelMethodCallHandler(MethodCall call) {
    switch (call.method) {
      case "initialized":
        initializedController.add(true);
        break;
      case "result":
        candidatesController
            .add(call.arguments.map((x) => x[1]).cast<String>().toList());
        break;
      case "error":
        errorController.add(call.arguments);
        break;
      default:
        throw UnsupportedError(call.method);
    }
  }


}