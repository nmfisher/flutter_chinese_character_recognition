import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class ChineseCharacterRecognition {
  static const MethodChannel _channel =
      const MethodChannel('chinese_character_recognition');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  StreamController<bool> _initializedController =
      StreamController<bool>.broadcast();

  Stream<bool> get initialized => _initializedController.stream;

  StreamController<List<String>> _candidatesController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get candidates => _candidatesController.stream;

  StreamController<String> _errorController = StreamController<String>();
  Stream<String> get error => _errorController.stream;

  static const int NUM_CANDIDATES = 8;
  static final _singleton = ChineseCharacterRecognition._internal();

  factory ChineseCharacterRecognition() {
    return _singleton;
  }

  ChineseCharacterRecognition._internal() {
    _channel.setMethodCallHandler(channelMethodCallHandler);
  }

  void initialize() async {
    await _channel.invokeMethod('initialize', NUM_CANDIDATES);
  }

  void recognize(List<List<Offset>> strokes) async {
    if (strokes.length == 0) {
      // the drawing canvas has been reset
      _candidatesController.add(null);
      return;
    }

    await _channel.invokeMethod(
        "lookup",
        strokes
            .where((stroke) => stroke.length > 1)
            .map((stroke) => stroke.map((pt) => [pt.dx, pt.dy]).toList()).toList());
  }

  Future<dynamic> channelMethodCallHandler(MethodCall call) {
    switch (call.method) {
      case "initialized":
        _initializedController.add(true);
        break;
      case "result":
        _candidatesController
            .add(call.arguments.map((x) => x[1]).cast<String>().toList());
        break;
      case "error":
        _errorController.add(call.arguments);
        break;
      default:
        throw UnsupportedError(call.method);
    }
  }

  void clear(dynamic sender) {
    _candidatesController.sink.add(null);
  }

  @override
  void dispose() {
    _candidatesController.close();
    _initializedController.close();
    _errorController.close();
  }
}
