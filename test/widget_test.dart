import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/widgets/summary_card.dart';

void main() {
  testWidgets('SummaryCard shows its label and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SummaryCard(
            label: 'Dépenses',
            value: '12k FCFA',
            icon: Icons.shopping_bag_outlined,
            color: Colors.red,
          ),
        ),
      ),
    );

    expect(find.text('Dépenses'), findsOneWidget);
    expect(find.text('12k FCFA'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });
}
