import 'package:flutter/material.dart';

Future<bool?> showDeleteAccountDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Account'),
      content: const Text('Are you sure? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}