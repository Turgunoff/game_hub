import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CreateChallengeFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateChallengeFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.add),
      label: const Text(
        'Create Challenge',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}