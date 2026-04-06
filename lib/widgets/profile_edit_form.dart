import 'package:flutter/material.dart';

import 'package:parking/widgets/app_button.dart';
import 'package:parking/widgets/app_text_field.dart';

class ProfileEditForm extends StatelessWidget {
  const ProfileEditForm({
    required this.nameCtrl,
    required this.plateCtrl,
    required this.onSave,
    this.nameError,
    this.plateError,
    super.key,
  });

  final TextEditingController nameCtrl;
  final TextEditingController plateCtrl;
  final VoidCallback onSave;
  final String? nameError;
  final String? plateError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Full Name',
          icon: Icons.person_outline,
          controller: nameCtrl,
          errorText: nameError,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Vehicle Plate',
          hint: 'AA 1234 BB',
          icon: Icons.directions_car_outlined,
          controller: plateCtrl,
          errorText: plateError,
        ),
        const SizedBox(height: 24),
        AppButton(label: 'Save Changes', onPressed: onSave),
      ],
    );
  }
}
