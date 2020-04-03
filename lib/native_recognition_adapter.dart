library flutter_chinese_character_recognition;

import 'dart:ui';
import 'package:chinese_character_recognition/native_interop.dart';
import 'package:chinese_character_recognition/recognition_adapter.dart';

RecognitionAdapter getAdapter(int numCandidates) => NativeRecognitionAdapter(numCandidates);

class NativeRecognitionAdapter extends RecognitionAdapter {

  void lookup(List<List<Offset>> strokes) {
    if (strokes.length == 0) {
      // the drawing canvas has been reset
      candidatesController.add(null);
      return;
    }
    
    var candidates = nativeLookup(strokes.map((x) => x.map((y) => [y.dx, y.dy]).toList()).toList(), this.numCandidates);
    candidatesController.sink.add(candidates);
  }

  NativeRecognitionAdapter._internal(int numCandidates) : super(numCandidates) {
  }

  factory NativeRecognitionAdapter(int numCandidates) {
    return NativeRecognitionAdapter._internal(numCandidates);
  }

  @override
  void initialize() {
    initializedController.sink.add(true);
  }

}