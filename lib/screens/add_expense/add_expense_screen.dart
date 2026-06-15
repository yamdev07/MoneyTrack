import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/date_helpers.dart';
import '../../core/money.dart';
import '../../models/expense_category.dart';
import '../../state/expense_controller.dart';
import '../../state/profile_controller.dart';
import '../../widgets/section_title.dart';
import 'widgets/amount_field.dart';
import 'widgets/category_picker.dart';

/// Form to record a new expense (montant, catégorie, date, description).
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.nourriture;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = Money.tryParse(_amountController.text)!;
    await context.read<ExpenseController>().addExpense(
          amount: amount,
          categoryId: _category.id,
          date: _date,
          description: _descriptionController.text.trim(),
        );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<ProfileController>().currency;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une dépense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            AmountField(controller: _amountController, currency: currency),
            const SizedBox(height: 24),
            const SectionTitle('Catégorie'),
            const SizedBox(height: 12),
            CategoryPicker(
              selected: _category,
              onSelected: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: 24),
            const SectionTitle('Date'),
            const SizedBox(height: 8),
            ListTile(
              onTap: _pickDate,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: AppColors.primary),
              title: Text(DateHelpers.formatDay(_date)),
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 16),
            const SectionTitle('Description'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Optionnel (ex. Taxi maison)',
              ),
              maxLength: 80,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
