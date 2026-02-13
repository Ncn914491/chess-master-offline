
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Stockfish parsing benchmark and correctness', () {
    // Generate test data
    final lines = List.generate(10000, (i) {
      if (i % 10 == 0) {
        return 'info depth 20 seldepth 30 multipv 1 score mate ${i % 10} nodes 1000000 nps 1000000 hashfull 50 tbhits 0 time 1000 pv e2e4 e7e5 g1f3 b8c6';
      }
      return 'info depth ${i % 30} seldepth 30 multipv 1 score cp ${i * 10} nodes 1000000 nps 1000000 hashfull 50 tbhits 0 time 1000 pv e2e4 e7e5 g1f3 b8c6';
    });

    // --- Baseline (Old Regex Implementation) ---
    final stopwatch = Stopwatch()..start();
    final RegExp _scoreCpRegex = RegExp(r'score cp (-?\d+)');
    final RegExp _scoreMateRegex = RegExp(r'score mate (-?\d+)');
    final RegExp _multiPvRegex = RegExp(r'multipv (\d+)');
    final RegExp _depthRegex = RegExp(r'depth (\d+)');
    final RegExp _pvMovesRegex = RegExp(r'pv (.+)$');

    int processedCount = 0;

    for (final line in lines) {
       if (line.startsWith('info') && line.contains('pv')) {
        final pvMatch = _multiPvRegex.firstMatch(line);
        final depthMatch = _depthRegex.firstMatch(line);
        final scoreMatch = _scoreCpRegex.firstMatch(line);
        final mateMatch = _scoreMateRegex.firstMatch(line);
        final pvMovesMatch = _pvMovesRegex.firstMatch(line);

        if (pvMovesMatch != null) {
          if (pvMatch != null) int.parse(pvMatch.group(1)!);
          if (depthMatch != null) int.parse(depthMatch.group(1)!);
          if (scoreMatch != null) int.parse(scoreMatch.group(1)!);
          if (mateMatch != null) int.parse(mateMatch.group(1)!);

          final moves = pvMovesMatch.group(1)!.split(' ');
          processedCount += moves.length;
        }
      }
    }

    stopwatch.stop();
    final baselineTime = stopwatch.elapsedMilliseconds;
    print('Baseline parsing 10000 lines took: ${baselineTime}ms');
    print('Baseline count: $processedCount');

    // --- Optimized (New String Parsing Implementation) ---
    final stopwatchOptimized = Stopwatch()..start();
    int processedCountOptimized = 0;

    // Logic matching the one in StockfishService._parseInfoLine (updated)
    ({int? depth, int? multipv, int? cp, int? mate, List<String>? moves}) parseInfoLine(String line) {
      int? depth;
      int? multipv;
      int? cp;
      int? mate;
      List<String>? moves;

      int? parseValue(String key) {
        final keyIndex = line.indexOf(key);
        if (keyIndex == -1) return null;

        final valStart = keyIndex + key.length;
        int valEnd = line.indexOf(' ', valStart);
        if (valEnd == -1) valEnd = line.length;

        return int.tryParse(line.substring(valStart, valEnd));
      }

      depth = parseValue('depth ');
      multipv = parseValue('multipv ');
      cp = parseValue('cp ');
      mate = parseValue('mate ');

      final pvIndex = line.indexOf(' pv ');
      if (pvIndex != -1) {
        final movesStart = pvIndex + 4;
        final movesStr = line.substring(movesStart);
        moves = movesStr.split(' ');
      }
      return (depth: depth, multipv: multipv, cp: cp, mate: mate, moves: moves);
    }

    for (final line in lines) {
      if (line.startsWith('info') && line.contains(' pv ')) {
        final info = parseInfoLine(line);
        if (info.moves != null) {
          processedCountOptimized += info.moves!.length;
        }
      }
    }

    stopwatchOptimized.stop();
    final optimizedTime = stopwatchOptimized.elapsedMilliseconds;
    print('Optimized parsing 10000 lines took: ${optimizedTime}ms');
    print('Optimized count: $processedCountOptimized');

    // Assertions
    expect(processedCountOptimized, 40000, reason: "Optimized parser should correctly identify 4 moves per line");
    expect(optimizedTime < baselineTime, isTrue, reason: "Optimized parser should be faster than baseline");
  });
}
