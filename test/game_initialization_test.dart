import 'package:flutter_test/flutter_test.dart';
import 'package:chess_master/providers/game_provider.dart';
import 'package:chess_master/models/game_model.dart';
import 'package:chess_master/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Game Initialization Tests', () {
    test('should initialize game state correctly', () {
      final container = ProviderContainer();
      final gameNotifier = container.read(gameProvider.notifier);

      // Test basic game initialization
      gameNotifier.startNewGame(
        playerColor: PlayerColor.white,
        difficulty: AppConstants.difficultyLevels[0],
        timeControl: AppConstants.timeControls[0],
        gameMode: GameMode.bot,
      );

      final gameState = container.read(gameProvider);

      // Verify game state is properly initialized
      expect(gameState.status, GameStatus.active);
      expect(gameState.playerColor, PlayerColor.white);
      expect(
        gameState.board.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      );
      expect(gameState.moveHistory, isEmpty);
      expect(gameState.isWhiteTurn, true);

      container.dispose();
    });

    test('should handle random color selection', () {
      final container = ProviderContainer();
      final gameNotifier = container.read(gameProvider.notifier);

      // Test random color selection
      gameNotifier.startNewGame(
        playerColor: PlayerColor.random,
        difficulty: AppConstants.difficultyLevels[0],
        timeControl: AppConstants.timeControls[0],
        gameMode: GameMode.bot,
      );

      final gameState = container.read(gameProvider);

      // Verify random color was resolved to either white or black
      expect(
        gameState.playerColor == PlayerColor.white ||
            gameState.playerColor == PlayerColor.black,
        true,
      );
      expect(gameState.status, GameStatus.active);

      container.dispose();
    });

    test('should initialize board display correctly', () {
      final container = ProviderContainer();
      final gameNotifier = container.read(gameProvider.notifier);

      gameNotifier.startNewGame(
        playerColor: PlayerColor.white,
        difficulty: AppConstants.difficultyLevels[0],
        timeControl: AppConstants.timeControls[0],
        gameMode: GameMode.bot,
      );

      final gameState = container.read(gameProvider);

      // Test that all pieces are in starting positions
      expect(gameNotifier.getPieceAt('a1'), 'wR'); // White rook
      expect(gameNotifier.getPieceAt('b1'), 'wN'); // White knight
      expect(gameNotifier.getPieceAt('c1'), 'wB'); // White bishop
      expect(gameNotifier.getPieceAt('d1'), 'wQ'); // White queen
      expect(gameNotifier.getPieceAt('e1'), 'wK'); // White king
      expect(gameNotifier.getPieceAt('f1'), 'wB'); // White bishop
      expect(gameNotifier.getPieceAt('g1'), 'wN'); // White knight
      expect(gameNotifier.getPieceAt('h1'), 'wR'); // White rook

      // Test white pawns
      for (String file in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']) {
        expect(gameNotifier.getPieceAt('${file}2'), 'wP');
      }

      // Test black pieces
      expect(gameNotifier.getPieceAt('a8'), 'bR'); // Black rook
      expect(gameNotifier.getPieceAt('e8'), 'bK'); // Black king

      // Test black pawns
      for (String file in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']) {
        expect(gameNotifier.getPieceAt('${file}7'), 'bP');
      }

      // Test empty squares
      expect(gameNotifier.getPieceAt('e4'), null);
      expect(gameNotifier.getPieceAt('d5'), null);

      container.dispose();
    });

    test('should handle local multiplayer mode', () {
      final container = ProviderContainer();
      final gameNotifier = container.read(gameProvider.notifier);

      gameNotifier.startNewGame(
        playerColor: PlayerColor.white,
        difficulty: AppConstants.difficultyLevels[0],
        timeControl: AppConstants.timeControls[0],
        gameMode: GameMode.localMultiplayer,
      );

      final gameState = container.read(gameProvider);

      expect(gameState.gameMode, GameMode.localMultiplayer);
      expect(gameState.isLocalMultiplayer, true);
      expect(gameState.isPlayerTurn, true); // Always true in local multiplayer

      container.dispose();
    });
  });
}
