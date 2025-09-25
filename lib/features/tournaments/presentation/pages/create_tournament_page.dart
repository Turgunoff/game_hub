import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/game_selection_card.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _prizePoolController = TextEditingController();
  final _maxParticipantsController = TextEditingController();

  String? _selectedGame;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  DateTime _registrationDeadline = DateTime.now().add(const Duration(hours: 12));

  final List<String> _rules = ['Fair play required', 'No cheating allowed'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _entryFeeController.dispose();
    _prizePoolController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Tournament',
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
              _buildBasicInfo(),
              const SizedBox(height: 24),
              _buildGameSelection(),
              const SizedBox(height: 24),
              _buildFinancialInfo(),
              const SizedBox(height: 24),
              _buildSchedule(),
              const SizedBox(height: 24),
              _buildRules(),
              const SizedBox(height: 32),
              _buildCreateButton(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tournament Name',
                hintText: 'Enter tournament name',
                prefixIcon: Icon(Icons.emoji_events),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter tournament name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your tournament',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxParticipantsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Maximum Participants',
                hintText: 'e.g. 64',
                prefixIcon: Icon(Icons.people),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter maximum participants';
                }
                final number = int.tryParse(value);
                if (number == null || number < 2) {
                  return 'Must be at least 2 participants';
                }
                return null;
              },
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
              itemCount: AppConstants.gameTypes.length,
              itemBuilder: (context, index) {
                final game = AppConstants.gameTypes[index];
                return GameSelectionCard(
                  gameName: game,
                  isSelected: _selectedGame == game,
                  onTap: () {
                    setState(() {
                      _selectedGame = game;
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

  Widget _buildFinancialInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Details',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _entryFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Entry Fee (\$)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter entry fee';
                      }
                      final fee = double.tryParse(value);
                      if (fee == null || fee < 0) {
                        return 'Invalid fee amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Auto-calculate prize pool
                      final fee = double.tryParse(value);
                      final maxParticipants = int.tryParse(_maxParticipantsController.text);
                      if (fee != null && maxParticipants != null) {
                        final prizePool = fee * maxParticipants * 0.8; // 80% to prize pool
                        _prizePoolController.text = prizePool.toStringAsFixed(2);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _prizePoolController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Prize Pool (\$)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter prize pool';
                      }
                      final prize = double.tryParse(value);
                      if (prize == null || prize < 0) {
                        return 'Invalid prize amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.neonGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Prize pool is automatically calculated as 80% of total entry fees collected.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neonGreen,
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

  Widget _buildSchedule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(
              'Registration Deadline',
              _registrationDeadline,
              Icons.app_registration,
              (date) => setState(() => _registrationDeadline = date),
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(
              'Tournament Start',
              _startDate,
              Icons.play_arrow,
              (date) => setState(() => _startDate = date),
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(
              'Tournament End',
              _endDate,
              Icons.flag,
              (date) => setState(() => _endDate = date),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(
    String label,
    DateTime dateTime,
    IconData icon,
    Function(DateTime) onDateChanged,
  ) {
    return InkWell(
      onTap: () => _selectDateTime(dateTime, onDateChanged),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium,
                ),
                Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit, color: AppColors.onSurfaceSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildRules() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tournament Rules',
                  style: AppTextStyles.headline4,
                ),
                TextButton.icon(
                  onPressed: _addRule,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Rule'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._rules.asMap().entries.map((entry) {
              final index = entry.key;
              final rule = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rule,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      onPressed: () => _removeRule(index),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _createTournament,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primary,
        ),
        child: Text(
          'Create Tournament',
          style: AppTextStyles.buttonText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(
    DateTime initialDate,
    Function(DateTime) onDateChanged,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onDateChanged(newDateTime);
      }
    }
  }

  void _addRule() {
    showDialog(
      context: context,
      builder: (context) {
        String newRule = '';
        return AlertDialog(
          title: const Text('Add Tournament Rule'),
          content: TextField(
            onChanged: (value) => newRule = value,
            decoration: const InputDecoration(
              hintText: 'Enter tournament rule',
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newRule.isNotEmpty) {
                  setState(() {
                    _rules.add(newRule);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeRule(int index) {
    setState(() {
      _rules.removeAt(index);
    });
  }

  void _createTournament() {
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

    // Validate dates
    if (_registrationDeadline.isAfter(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration deadline must be before tournament start'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_startDate.isAfter(_endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tournament start must be before end date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show success and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tournament created successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }
}