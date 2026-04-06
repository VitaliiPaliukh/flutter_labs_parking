import 'package:flutter/material.dart';

import '../core/app_dependencies.dart';
import '../domain/user_validator.dart';
import '../models/user.dart';
import '../widgets/app_button.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/profile_edit_form.dart';
import '../widgets/profile_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _editing = false;
  bool _loading = true;
  String? _nameErr;
  String? _plateErr;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _plateCtrl;

  final _repo = AppDependencies().userRepository;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _plateCtrl = TextEditingController();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final email = await _repo.getSession();
    if (email == null || !mounted) return;
    final user = await _repo.getUser(email);
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
      _nameCtrl.text = user?.name ?? '';
      _plateCtrl.text = user?.vehiclePlate ?? '';
    });
  }

  Future<void> _saveChanges() async {
    final nameErr = UserValidator.validateName(_nameCtrl.text.trim());
    final plateErr = UserValidator.validatePlate(_plateCtrl.text.trim());
    setState(() {
      _nameErr = nameErr;
      _plateErr = plateErr;
    });
    if (nameErr != null || plateErr != null) return;
    final updated = _user!.copyWith(
      name: _nameCtrl.text.trim(),
      vehiclePlate: _plateCtrl.text.trim(),
    );
    await _repo.updateUser(updated);
    if (!mounted) return;
    setState(() {
      _user = updated;
      _editing = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDeleteAccountDialog(context);
    if (confirmed != true || !mounted) return;
    await _repo.deleteUser(_user!.email);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  Future<void> _signOut() async {
    await _repo.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
        _nameCtrl.text = _user?.name ?? '';
        _plateCtrl.text = _user?.vehiclePlate ?? '';
        _nameErr = null;
        _plateErr = null;
      }
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.2 : 24.0;
    final primary = Theme.of(context).colorScheme.primary;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.close : Icons.edit_outlined),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: primary,
              child: Text(
                _user?.name[0].toUpperCase() ?? '?',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _user?.email ?? '',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            if (_editing)
              ProfileEditForm(
                nameCtrl: _nameCtrl,
                plateCtrl: _plateCtrl,
                onSave: _saveChanges,
                nameError: _nameErr,
                plateError: _plateErr,
              )
            else
              ProfileInfoCard(user: _user!),
            const SizedBox(height: 28),
            AppButton(label: 'Sign Out', outlined: true, onPressed: _signOut),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _deleteAccount,
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}