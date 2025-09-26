import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../tournaments/presentation/widgets/game_selection_card.dart';
import '../../domain/entities/challenge.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key});

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _wagerController = TextEditingController();
  final _opponentController = TextEditingController();

  String? _selectedGame;
  ChallengeType _challengeType = ChallengeType.public;
  final Map<String, dynamic> _gameSettings = {};

  @override
  void dispose() {
    _descriptionController.dispose();
    _wagerController.dispose();
    _opponentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Challenge',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChallengeType(),
              const SizedBox(height: 24),
              _buildGameSelection(),
              const SizedBox(height: 24),
              _buildOpponentSelection(),
              const SizedBox(height: 24),
              _buildWagerSection(),
              const SizedBox(height: 24),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildGameSettings(),
              const SizedBox(height: 32),
              _buildCreateButton(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeType() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challenge Type',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                    ChallengeType.public,
                    'Open Challenge',
                    'Anyone can accept',
                    Icons.public,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeOption(
                    ChallengeType.oneVsOne,
                    '1v1 Challenge',
                    'Challenge specific player',
                    Icons.person_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(ChallengeType type, String title, String subtitle, IconData icon) {
    final isSelected = _challengeType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _challengeType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? Colors.white : AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white70 : AppColors.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Game',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: AppConstants.gameTypes.take(4).length, // Show only main games
              itemBuilder: (context, index) {
                final game = AppConstants.gameTypes[index];
                return GameSelectionCard(
                  gameName: game,
                  isSelected: _selectedGame == game,
                  onTap: () {
                    setState(() {
                      _selectedGame = game;
                      _updateGameSettings(game);
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpponentSelection() {
    if (_challengeType == ChallengeType.public) {
      return const SizedBox();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opponent',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _opponentController,
              decoration: const InputDecoration(
                labelText: 'Username or Player ID',
                hintText: 'Enter opponent username',
                prefixIcon: Icon(Icons.person_search),
              ),
              validator: (value) {
                if (_challengeType == ChallengeType.oneVsOne) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter opponent username';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Leave empty for open challenge',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWagerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.neonGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wager (Optional)',
                  style: AppTextStyles.headline4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _wagerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Wager Amount (\$)',
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value?.isNotEmpty ?? false) {
                  final wager = double.tryParse(value!);
                  if (wager == null || wager < 0) {
                    return 'Invalid wager amount';
                  }
                  if (wager > 1000) {
                    return 'Maximum wager is \$1000';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Winner takes the wager. Both players must agree to the amount.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description (Optional)',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Challenge Description',
                hintText: 'Add details about your challenge...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSettings() {
    if (_selectedGame == null || _gameSettings.isEmpty) {
      return const SizedBox();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Settings',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            ..._gameSettings.entries.map((entry) {
              return _buildSettingItem(entry.key, entry.value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatSettingName(key),
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 8),
          if (value is List<String>) ...[
            DropdownButtonFormField<String>(
              initialValue: _gameSettings[key] as String?,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: value.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gameSettings[key] = newValue;
                });
              },
            ),
          ] else if (value is bool) ...[
            SwitchListTile(
              title: Text('Enable $key'),
              value: _gameSettings[key] as bool? ?? false,
              onChanged: (newValue) {
                setState(() {
                  _gameSettings[key] = newValue;
                });
              },
            ),
          ] else ...[
            TextFormField(
              initialValue: _gameSettings[key]?.toString(),
              onChanged: (newValue) {
                setState(() {
                  _gameSettings[key] = newValue;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _createChallenge,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.secondary,
        ),
        child: Text(
          'Create Challenge',
          style: AppTextStyles.buttonText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _updateGameSettings(String game) {
    _gameSettings.clear();

    switch (game) {
      case 'PES Mobile 2026':
        _gameSettings.addAll({
          'matchLength': ['10 minutes', '15 minutes', '20 minutes'],
          'difficulty': ['Professional', 'World Class', 'Legend'],
        });
        // Set default values
        _gameSettings['matchLength'] = '10 minutes';
        _gameSettings['difficulty'] = 'Professional';
        break;
      case 'PUBG Mobile':
        _gameSettings.addAll({
          'mode': ['Classic', 'Arcade'],
          'map': ['Erangel', 'Sanhok', 'Miramar'],
          'perspective': ['TPP', 'FPP'],
        });
        _gameSettings['mode'] = 'Classic';
        _gameSettings['map'] = 'Erangel';
        _gameSettings['perspective'] = 'TPP';
        break;
      case 'Free Fire':
        _gameSettings.addAll({
          'mode': ['Classic', 'Clash Squad'],
          'map': ['Bermuda', 'Purgatory', 'Kalahari'],
        });
        _gameSettings['mode'] = 'Classic';
        _gameSettings['map'] = 'Bermuda';
        break;
      case 'Call of Duty Mobile':
        _gameSettings.addAll({
          'mode': ['Team Deathmatch', 'Search & Destroy', 'Domination'],
          'map': ['Nuketown', 'Crash', 'Firing Range'],
          'rounds': ['Best of 3', 'Best of 5'],
        });
        _gameSettings['mode'] = 'Team Deathmatch';
        _gameSettings['map'] = 'Nuketown';
        _gameSettings['rounds'] = 'Best of 3';
        break;
    }
  }

  String _formatSettingName(String key) {
    return key.split(RegExp(r'(?=[A-Z])')).map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void _createChallenge() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a game'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show success and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _challengeType == ChallengeType.public
              ? 'Open challenge created! Waiting for opponents.'
              : 'Challenge sent! Waiting for response.',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }
}