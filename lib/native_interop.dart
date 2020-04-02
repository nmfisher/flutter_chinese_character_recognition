import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:ui';
import 'package:ffi/ffi.dart';

ffi.DynamicLibrary dl = ffi.DynamicLibrary.open("libhanzi_lookup.so");

typedef NativeLookupFunction = Uint8 Function(
    Pointer<Stroke>, Uint8 numStrokes, Pointer<Match>, Uint8 numMatches);
typedef NativeLookupFunctionDart = int Function(
    Pointer<Stroke>, int numStrokes, Pointer<Match>, int numMatches);

class Match extends Struct {
  @ffi.Uint32()
  int hanzi;
  
  @ffi.Double()
  double score;
}

List<String> nativeLookup(List<List<Offset>> strokes, int numCandidates) {
  var matches = allocate<Match>(count: numCandidates);
  var strokePtrs = allocate<Stroke>(count: strokes.length);

  for (int i = 0; i < strokes.length; i++) {
    Point point;
    for (var j = 0; j < strokes[i].length; j++) {
      point = Point.allocate(strokes[i][j].dx, strokes[i][j].dy);
    }
    strokePtrs.elementAt(i).ref.points = point.addressOf;
    strokePtrs.elementAt(i).ref.num_points = strokes[i].length;
  }
  var lookupFn =
      dl.lookupFunction<NativeLookupFunction, NativeLookupFunctionDart>(
          "lookupFFI");
  lookupFn(strokePtrs, strokes.length, matches, numCandidates);
  var matchList = List.generate(numCandidates, (index) => matches.elementAt(index));
  matchList.sort((a,b) => b.ref.score.compareTo((a.ref.score)));
  return matchList.map((x) => String.fromCharCode(x.ref.hanzi)).toList();
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
