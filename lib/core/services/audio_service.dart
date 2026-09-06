import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for playing chess game sounds without blocking the UI thread.
class AudioService {
  static AudioService? _instance;
  final AudioPlayer _movePlayer = AudioPlayer();
  final AudioPlayer _capturePlayer = AudioPlayer();
  final AudioPlayer _checkPlayer = AudioPlayer();
  final AudioPlayer _gameEndPlayer = AudioPlayer();

  bool _enabled = true;
  bool _initialized = false;
  bool _isInitializing = false;

  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  AudioService._() {
    _configureAudioContext();
  }

  /// Set up audio context for low latency playback
  void _configureAudioContext() {
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.none,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient,
            options: const {AVAudioSessionOptions.mixWithOthers},
          ),
        ),
      );
    } catch (e) {
      debugPrint('AudioService: Failed to configure AudioContext: $e');
    }
  }

  /// Non-blocking, lazy audio player initialization
  Future<void> initialize() async {
    if (_initialized || _isInitializing) return;
    _isInitializing = true;

    // Run initialization asynchronously off the main frame loop
    unawaited(
      runZonedGuarded(
        () async {
          try {
            await _movePlayer.setReleaseMode(ReleaseMode.stop);
            await _capturePlayer.setReleaseMode(ReleaseMode.stop);
            await _checkPlayer.setReleaseMode(ReleaseMode.stop);
            await _gameEndPlayer.setReleaseMode(ReleaseMode.stop);

            // Preload sources
            await _movePlayer.setSource(AssetSource('sounds/move.mp3'));
            await _capturePlayer.setSource(AssetSource('sounds/capture.mp3'));
            await _checkPlayer.setSource(AssetSource('sounds/check.mp3'));
            await _gameEndPlayer.setSource(AssetSource('sounds/game_end.mp3'));

            _initialized = true;
          } catch (e) {
            debugPrint('Failed to initialize audio service sources: $e');
          } finally {
            _isInitializing = false;
          }
        },
        (error, stack) {
          debugPrint('AudioService init error: $error');
          _isInitializing = false;
        },
      ),
    );
  }

  /// Enable or disable sound effects
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Safely play audio on a player without blocking main UI thread or throwing
  void _playSound(AudioPlayer player, AssetSource source) {
    if (!_enabled) return;
    unawaited(
      runZonedGuarded(
        () async {
          try {
            if (_initialized) {
              await player.seek(Duration.zero);
              await player.resume();
            } else {
              await player.stop();
              await player.play(source);
            }
          } catch (e) {
            debugPrint('Error playing sound ${source.path}: $e');
          }
        },
        (error, stack) {
          debugPrint('AudioService sound exception: $error');
        },
      ),
    );
  }

  /// Play move sound
  Future<void> playMove() async {
    _playSound(_movePlayer, AssetSource('sounds/move.mp3'));
  }

  /// Play capture sound
  Future<void> playCapture() async {
    _playSound(_capturePlayer, AssetSource('sounds/capture.mp3'));
  }

  /// Play check sound
  Future<void> playCheck() async {
    _playSound(_checkPlayer, AssetSource('sounds/check.mp3'));
  }

  /// Play castle sound
  Future<void> playCastle() async {
    await playMove();
  }

  /// Play game start sound
  Future<void> playGameStart() async {
    _playSound(_movePlayer, AssetSource('sounds/game_start.mp3'));
  }

  /// Play game end sound
  Future<void> playGameEnd() async {
    _playSound(_gameEndPlayer, AssetSource('sounds/game_end.mp3'));
  }

  /// Play low time warning
  Future<void> playLowTime() async {
    _playSound(_movePlayer, AssetSource('sounds/low_time.mp3'));
  }

  /// Play sound based on move type
  Future<void> playMoveSound({
    bool isCapture = false,
    bool isCheck = false,
    bool isCheckmate = false,
    bool isCastle = false,
  }) async {
    if (isCheckmate) {
      await playGameEnd();
    } else if (isCheck) {
      await playCheck();
    } else if (isCapture) {
      await playCapture();
    } else if (isCastle) {
      await playCastle();
    } else {
      await playMove();
    }
  }

  /// Dispose audio players safely
  void dispose() {
    _movePlayer.dispose();
    _capturePlayer.dispose();
    _checkPlayer.dispose();
    _gameEndPlayer.dispose();
  }
}

/// Provider for audio service
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService.instance;
});
