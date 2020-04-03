import 'dart:async';
import 'dart:ui';

abstract class RecognitionAdapter {

  RecognitionAdapter(this.numCandidates);

  int numCandidates;

  StreamController<bool> initializedController =
      StreamController<bool>.broadcast();

  Stream<bool> get initialized => initializedController.stream;

  StreamController<List<String>> candidatesController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get candidates => candidatesController.stream;

  StreamController<String> errorController = StreamController<String>();
  Stream<String> get error => errorController.stream;

  void lookup(List<List<Offset>> strokes);
  
  void clear() {
    candidatesController.sink.add(null);
  }

  void initialize();


  void dispose() {
    candidatesController.close();
    initializedController.close();
    errorController.close();
  }
}