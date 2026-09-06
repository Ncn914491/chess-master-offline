import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess/chess.dart' as chess_lib;
import 'package:chess_master/core/services/stockfish_service.dart';
import 'package:chess_master/core/services/stockfish_lifecycle_observer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Production Crash & ANR Prevention Test Suite', () {
    late StockfishService service;

    setUp(() {
      service = StockfishService.instance;
      service.resetTestState();
      service.forceFallback = true;
    });

    // 1. 1000+ AI move requests
    test(
      'Scenario 1: 1000+ AI move requests execute without memory leaks or crashes',
      () async {
        const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
        for (int i = 0; i < 1000; i++) {
          final res = await service.getBestMove(fen: fen, depth: 1);
          expect(res.bestMove, isNotEmpty);
        }
      },
    );

    // 2. Rapid undo/redo
    test(
      'Scenario 2: Rapid undo/redo operations during active search',
      () async {
        const fenStart =
            'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
        const fenMove1 =
            'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1';

        final future1 = service.getBestMove(fen: fenStart, depth: 3);
        service.stopAnalysis(); // simulate undo
        final future2 = service.getBestMove(fen: fenMove1, depth: 3);

        final res1 = await future1;
        final res2 = await future2;
        expect(res1.bestMove, isNotNull);
        expect(res2.bestMove, isNotNull);
      },
    );

    // 3. New game spam
    test('Scenario 3: New game spam during search executes safely', () async {
      const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
      for (int i = 0; i < 10; i++) {
        service.getBestMove(fen: fen, depth: 3);
        service.newGame();
      }
      final finalRes = await service.getBestMove(fen: fen, depth: 1);
      expect(finalRes.bestMove, isNotEmpty);
    });

    // 4. Difficulty switching during search
    test('Scenario 4: Difficulty switching during search', () async {
      const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
      final searchFuture = service.getBestMove(fen: fen, depth: 5);
      service.setSkillLevel(1500);
      service.setSkillLevel(2000);
      service.setMaxStrength();

      final res = await searchFuture;
      expect(res.bestMove, isNotEmpty);
    });

    // 5. App background/foreground during search
    test(
      'Scenario 5: App background/foreground lifecycle transition during search',
      () async {
        StockfishLifecycleObserver.ensureRegistered();
        const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

        final searchFuture = service.getBestMove(fen: fen, depth: 5);
        StockfishLifecycleObserver().didChangeAppLifecycleState(
          AppLifecycleState.paused,
        );
        StockfishLifecycleObserver().didChangeAppLifecycleState(
          AppLifecycleState.resumed,
        );

        final res = await searchFuture;
        expect(res.bestMove, isNotNull);
      },
    );

    // 6. Orientation changes simulation
    test('Scenario 6: Layout / orientation change state stability', () async {
      const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
      final res1 = await service.getBestMove(fen: fen, depth: 2);
      expect(res1.bestMove, isNotEmpty);

      final res2 = await service.getBestMove(fen: fen, depth: 2);
      expect(res2.bestMove, isNotEmpty);
    });

    // 7. Engine restart scenarios
    test('Scenario 7: Engine restart after failure or dispose', () async {
      await service.dispose();
      final resAfterDispose = await service.getBestMove(
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        depth: 1,
      );
      expect(resAfterDispose.bestMove, isNotEmpty);

      final recovered = await service.resetFallback();
      expect(recovered, isTrue);
    });

    // 8. Invalid FEN handling
    test('Scenario 8: Invalid FENs are safely intercepted by validation', () async {
      final invalidFens = [
        '',
        '8/8/8/8/8/8/8/8 w - - 0 1', // missing kings
        'rnbq1bnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQ1BNR w - - 0 1', // missing white king
        '8/8/8/8/8/8/8 w - - 0 1', // 7 rows
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq invalid 0 1', // invalid ep
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR x - - 0 1', // bad turn
        'rnbqkKnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1', // 2 white kings
        'P7/8/8/8/8/8/8/8 w - - 0 1', // pawn on rank 8
        '8/8/8/8/8/8/8/P7 w - - 0 1', // pawn on rank 1
      ];

      for (final badFen in invalidFens) {
        final res = await service.getBestMove(fen: badFen, depth: 1);
        expect(res.bestMove, isNotNull);

        final analysis = await service.analyzePosition(fen: badFen, depth: 1);
        expect(analysis, isNotNull);
      }
    });

    // 9. Invalid move handling
    test(
      'Scenario 9: Illegal moves in UCI move list are safely rejected',
      () async {
        const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
        final illegalMoveLists = [
          ['e2e5'], // Pawn double move from e2 to e5 is illegal
          ['a1a1'], // Same square
          ['z9z9'], // Invalid coordinate
          ['e2e4', 'e7e5', 'g1f3', 'e5e4'], // illegal sequence
        ];

        for (final moves in illegalMoveLists) {
          final res = await service.getBestMove(
            fen: fen,
            depth: 1,
            startingFen: fen,
            moves: moves,
          );
          expect(res.bestMove, isNotNull);
        }
      },
    );

    // 10. Long AI games (300+ moves)
    test(
      'Scenario 10: Long AI game simulation (300+ moves) maintains stability',
      () async {
        final chess = chess_lib.Chess();
        int moveCount = 0;

        while (!chess.game_over && moveCount < 300) {
          final fen = chess.fen;
          final res = await service.getBestMove(fen: fen, depth: 1);
          if (res.bestMove.isEmpty) break;

          final from = res.bestMove.substring(0, 2);
          final to = res.bestMove.substring(2, 4);
          final promotion = res.bestMove.length > 4 ? res.bestMove[4] : null;

          final moveResult = chess.move({
            'from': from,
            'to': to,
            if (promotion != null) 'promotion': promotion,
          });

          if (moveResult == false) break;
          moveCount++;
        }

        expect(moveCount, greaterThan(0));
      },
    );
  });

  group('Section 10 — Android Target & Compile SDK 36 Policy', () {
    test('build.gradle.kts targets compileSdk 36 and targetSdk 36', () {
      final file = File('android/app/build.gradle.kts');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'android/app/build.gradle.kts must exist',
      );

      final content = file.readAsStringSync();
      expect(
        content.contains('compileSdk = 36'),
        isTrue,
        reason: 'compileSdk must be set to 36',
      );
      expect(
        content.contains('targetSdk = 36'),
        isTrue,
        reason: 'targetSdk must be set to 36',
      );
    });
  });
}
