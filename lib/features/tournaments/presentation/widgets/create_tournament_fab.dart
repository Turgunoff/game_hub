import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CreateTournamentFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateTournamentFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.add),
      label: const Text(
        'Create Tournament',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}