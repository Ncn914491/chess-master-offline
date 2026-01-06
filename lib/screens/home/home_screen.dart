import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chess_master/core/theme/app_theme.dart';
import 'package:chess_master/core/constants/app_constants.dart';
import 'package:chess_master/core/services/database_service.dart';
import 'package:chess_master/providers/game_provider.dart';
import 'package:chess_master/providers/settings_provider.dart';
import 'package:chess_master/providers/engine_provider.dart';
import 'package:chess_master/screens/game/game_screen.dart';
import 'package:chess_master/screens/history/game_history_screen.dart';
import 'package:chess_master/screens/puzzles/puzzle_menu_screen.dart';
import 'package:chess_master/screens/analysis/analysis_screen.dart';

/// Home screen with main menu
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // App logo and title
              _buildHeader(context),
              const SizedBox(height: 48),

              // Main menu buttons
              Expanded(
                child: _buildMenuButtons(context, ref),
              ),

              // Quick start section
              _buildQuickStart(context, ref),
              const SizedBox(height: 24),

              // Version info
              Text(
                'Version ${AppConstants.appVersion}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Chess piece icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '♔',
              style: TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Master the game of kings',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _MenuButton(
            icon: Icons.play_arrow_rounded,
            label: 'New Game',
            subtitle: 'Play against the bot',
            color: AppTheme.primaryColor,
            onTap: () => _showNewGameDialog(context, ref),
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.play_circle_outline,
            label: 'Continue Game',
            subtitle: 'Resume your last game',
            onTap: () => _continueLastGame(context, ref),
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.folder_outlined,
            label: 'Load Game',
            subtitle: 'View game history',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameHistoryScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.extension_outlined,
            label: 'Puzzles',
            subtitle: 'Solve tactical puzzles',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PuzzleMenuScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.analytics_outlined,
            label: 'Analysis',
            subtitle: 'Analyze any position',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalysisScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.bar_chart_outlined,
            label: 'Statistics',
            subtitle: 'View your progress',
            onTap: () {
              // TODO: Navigate to statistics
            },
          ),
          const SizedBox(height: 12),
          _MenuButton(
            icon: Icons.settings_outlined,
            label: 'Settings',
            subtitle: 'Customize your experience',
            onTap: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStart(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Quick Start',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickStartButton(
                  label: 'Easy',
                  elo: 1200,
                  onTap: () => _startQuickGame(context, ref, 3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickStartButton(
                  label: 'Medium',
                  elo: 1600,
                  onTap: () => _startQuickGame(context, ref, 5),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickStartButton(
                  label: 'Hard',
                  elo: 2000,
                  onTap: () => _startQuickGame(context, ref, 7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startQuickGame(BuildContext context, WidgetRef ref, int difficultyLevel) async {
    final difficulty = AppConstants.difficultyLevels[difficultyLevel - 1];

    // Initialize and reset engine
    final engineNotifier = ref.read(engineProvider.notifier);
    await engineNotifier.initialize();
    engineNotifier.resetForNewGame();

    ref.read(gameProvider.notifier).startNewGame(
          playerColor: PlayerColor.white,
          difficulty: difficulty,
          timeControl: AppConstants.timeControls[0], // No timer
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  Future<void> _continueLastGame(BuildContext context, WidgetRef ref) async {
    try {
      final dbService = ref.read(databaseServiceProvider);
      final lastGame = await dbService.getLastUnfinishedGame();

      if (lastGame == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No saved game found')),
          );
        }
        return;
      }

      // Initialize engine
      final engineNotifier = ref.read(engineProvider.notifier);
      await engineNotifier.initialize();
      engineNotifier.resetForNewGame();

      // Load game settings
      final playerColorStr = lastGame['player_color'] as String? ?? 'white';
      final playerColor = playerColorStr == 'white' ? PlayerColor.white : PlayerColor.black;

      final botElo = lastGame['bot_elo'] as int? ?? 1200;
      final difficultyIndex = AppConstants.difficultyLevels
          .indexWhere((d) => d.elo == botElo)
          .clamp(0, AppConstants.difficultyLevels.length - 1);
      final difficulty = AppConstants.difficultyLevels[difficultyIndex];

      final timeControlStr = lastGame['time_control'] as String? ?? 'No Timer';
      final timeControlIndex = AppConstants.timeControls
          .indexWhere((tc) => tc.name == timeControlStr)
          .clamp(0, AppConstants.timeControls.length - 1);
      final timeControl = AppConstants.timeControls[timeControlIndex];

      final fenCurrent = lastGame['fen_current'] as String?;

      ref.read(gameProvider.notifier).startNewGame(
            playerColor: playerColor,
            difficulty: difficulty,
            timeControl: timeControl,
            startingFen: fenCurrent,
          );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GameScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading game: $e')),
        );
      }
    }
  }

  void _showNewGameDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewGameSheet(ref: ref),
    );
  }
}

/// Menu button widget
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardDark,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (color ?? AppTheme.surfaceDark).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color ?? AppTheme.textPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick start button
class _QuickStartButton extends StatelessWidget {
  final String label;
  final int elo;
  final VoidCallback onTap;

  const _QuickStartButton({
    required this.label,
    required this.elo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$elo ELO',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// New game configuration sheet
class _NewGameSheet extends StatefulWidget {
  final WidgetRef ref;

  const _NewGameSheet({required this.ref});

  @override
  State<_NewGameSheet> createState() => _NewGameSheetState();
}

class _NewGameSheetState extends State<_NewGameSheet> {
  PlayerColor _selectedColor = PlayerColor.white;
  int _selectedDifficulty = 5;
  int _selectedTimeControl = 0;

  @override
  void initState() {
    super.initState();
    final settings = widget.ref.read(settingsProvider);
    _selectedDifficulty = settings.lastDifficultyLevel;
    _selectedTimeControl = settings.lastTimeControlIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Game',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 24),

                // Color selection
                Text(
                  'Play as',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: PlayerColor.values.map((color) {
                    final isSelected = _selectedColor == color;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _ColorOption(
                          color: color,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedColor = color),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Difficulty selection
                Text(
                  'Difficulty: ${AppConstants.difficultyLevels[_selectedDifficulty - 1].name} '
                  '(${AppConstants.difficultyLevels[_selectedDifficulty - 1].elo} ELO)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Slider(
                  value: _selectedDifficulty.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: AppConstants.difficultyLevels[_selectedDifficulty - 1].name,
                  onChanged: (value) {
                    setState(() => _selectedDifficulty = value.round());
                  },
                ),
                const SizedBox(height: 24),

                // Time control selection
                Text(
                  'Time Control',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    AppConstants.timeControls.length,
                    (index) {
                      final tc = AppConstants.timeControls[index];
                      final isSelected = _selectedTimeControl == index;
                      return ChoiceChip(
                        label: Text(tc.name),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedTimeControl = index);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Start button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Start Game'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() async {
    final difficulty = AppConstants.difficultyLevels[_selectedDifficulty - 1];
    final timeControl = AppConstants.timeControls[_selectedTimeControl];

    // Save preferences
    widget.ref.read(settingsProvider.notifier).setLastDifficulty(_selectedDifficulty);
    widget.ref.read(settingsProvider.notifier).setLastTimeControl(_selectedTimeControl);

    // Initialize and reset engine
    final engineNotifier = widget.ref.read(engineProvider.notifier);
    await engineNotifier.initialize();
    engineNotifier.resetForNewGame();

    // Start game
    widget.ref.read(gameProvider.notifier).startNewGame(
          playerColor: _selectedColor,
          difficulty: difficulty,
          timeControl: timeControl,
        );

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }
}

/// Color selection option
class _ColorOption extends StatelessWidget {
  final PlayerColor color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.primaryColor : AppTheme.cardDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                color == PlayerColor.white
                    ? '♔'
                    : color == PlayerColor.black
                        ? '♚'
                        : '🎲',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                color.displayName,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
