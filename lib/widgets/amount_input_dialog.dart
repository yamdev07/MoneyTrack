import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/money.dart';

/// Reusable dialog that prompts for a positive amount.
///
/// Returns the parsed amount, or null if cancelled.
class AmountInputDialog {
  static Future<double?> show(
    BuildContext context, {
    required String title,
    required String currency,
    String confirmLabel = 'Valider',
    double? initialValue,
  }) {
    final controller = TextEditingController(
      text: initialValue != null && initialValue > 0
          ? initialValue.toStringAsFixed(0)
          : '',
    );
    final formKey = GlobalKey<FormState>();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(suffixText: currency),
              validator: (value) {
                final amount = Money.tryParse(value ?? '');
                if (amount == null || amount <= 0) {
                  return 'Montant invalide';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context, Money.tryParse(controller.text));
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }
}
