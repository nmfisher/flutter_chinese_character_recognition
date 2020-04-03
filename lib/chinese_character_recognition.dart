import 'dart:ui';
import 'package:chinese_character_recognition/recognition_adapter.dart';
import 'package:chinese_character_recognition/recognition_adapter_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'html_recognition_adapter.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'native_recognition_adapter.dart';
    

class ChineseCharacterRecognition {
 
  RecognitionAdapter _adapter;
  
  Stream<List<String>> get candidates => _adapter.candidates;
  Stream<bool> get initialized => _adapter.initialized;
  Stream<String> get error => _adapter.error;

  static const int NUM_CANDIDATES = 8;
  static final _singleton = ChineseCharacterRecognition._internal();

  factory ChineseCharacterRecognition() {
    return _singleton;
  }

  ChineseCharacterRecognition._internal() {
    _adapter = getAdapter(NUM_CANDIDATES);
  }

  void recognize(List<List<Offset>> strokes) async {
    strokes = strokes.where((stroke) => stroke.length > 1).toList();
    _adapter.lookup(strokes);
  }

  void initialize () {
    _adapter.initialize();
  }

  void clear() {
    _adapter.clear();
  }

  void dispose() {
    _adapter.dispose();
  }

}
