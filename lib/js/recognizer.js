var hanziLookupDemoApp = (function (window) {
  var wasmUri = 'hanzi_lookup_bg.wasm';
  const WORKER_PATH = "assets/packages/chinese_character_recognition/js/worker.js";
  var HandwritingRecognizer = function (numCandidates, onInit, onResult, onError) {

    var _worker;
    

    this.initialize = function () {
      _worker = new Worker(WORKER_PATH);
      _worker.onmessage = function (e) {
        if (!e.data.what) return;
        if (e.data.what == "loaded") onInit();
        else if (e.data.what == "lookup") {
          onResult(e.data.matches);
        } else if (e.data.what == "error") {
          console.error(e.data);
          onError(e.data.data);
        }
          
      };
      _worker.postMessage({ wasm_uri: wasmUri });
    }
    // Fetches hand-drawn input from drawing board and looks up Hanzi
    this.lookup = function (strokes) {
      _worker.postMessage({ strokes: strokes, limit: numCandidates });
    }
  }
  if(!window.flutter_chinese_character_recognition)
  window.flutter_chinese_character_recognition = {};
  
  window.flutter_chinese_character_recognition["HandwritingRecognizer"] = HandwritingRecognizer;

})((window));