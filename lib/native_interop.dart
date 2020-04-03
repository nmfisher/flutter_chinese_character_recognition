import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

ffi.DynamicLibrary dl = ffi.DynamicLibrary.open("libhanzi_lookup.so");

typedef NativeLookupFunction = Uint8 Function(
    Pointer<Stroke>, Uint8 numStrokes, Pointer<Match>, Uint8 numMatches);
typedef NativeLookupFunctionDart = int Function(
    Pointer<Stroke>, int numStrokes, Pointer<Match>, int numMatches);

class Match extends Struct {
  @ffi.Uint32()
  int hanzi;
  
  @ffi.Float()
  double score;
}

List<String> nativeLookup(List<List<List<double>>> strokes, int numCandidates) {
  var matches = allocate<Match>(count: numCandidates);
  var strokePtrs = allocate<Stroke>(count: strokes.length);

  for (int i = 0; i < strokes.length; i++) {
    var point = allocate<Point>(count:strokes[i].length);
    for (var j = 0; j < strokes[i].length; j++) {
      point.elementAt(j).ref.x = strokes[i][j][0];
      point.elementAt(j).ref.y = strokes[i][j][1];
    }
    strokePtrs.elementAt(i).ref.points = point;
    strokePtrs.elementAt(i).ref.num_points = strokes[i].length;
  }
  var lookupFn =
      dl.lookupFunction<NativeLookupFunction, NativeLookupFunctionDart>(
          "lookupFFI");
  int numResults = lookupFn(strokePtrs, strokes.length, matches, numCandidates);
  
  var matchList = List.generate(numResults, (index) => matches.elementAt(index).ref);
  
  matchList.sort((a,b) => b.score.compareTo((a.score)));
  return matchList.map((x) => x.hanzi <= 1114111 ? String.fromCharCode(x.hanzi) : '').toList();
}

void main() {
  // print(String.fromCharCode(20108));
  print(nativeLookup([[[70.0,124.0],[71,124],[79,124],[104,124],[119,124],[132,125],[151,126],[168,126],[169,126],[189,125],[191,124],[191,124]]], 5));
}


class Point extends Struct {
  @ffi.Double()
  double x;

  @ffi.Double()
  double y;

  factory Point.allocate(double x, double y
  ) {
    return allocate<Point>().ref
      ..x = x
      ..y = y
      ;
  }
}

class Stroke extends Struct {
  
  @ffi.Uint8()
  int num_points;
  
  Pointer<Point> points;

  factory Stroke.allocate(Pointer<Point> points, int num_points) {
    return allocate<Stroke>().ref..points = points..num_points=num_points;
  }
}
