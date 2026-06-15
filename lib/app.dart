import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'data/budget_repository.dart';
import 'data/expense_repository.dart';
import 'data/profile_repository.dart';
import 'data/savings_repository.dart';
import 'state/budget_controller.dart';
import 'state/expense_controller.dart';
import 'screens/home/home_shell.dart';
import 'state/profile_controller.dart';
import 'state/savings_controller.dart';

/// Root widget: wires repositories, controllers, theme and the home screen.
class MoneyTrackApp extends StatelessWidget {
  const MoneyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileController(ProfileRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseController(ExpenseRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetController(BudgetRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => SavingsController(SavingsRepository()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: const Locale('fr', 'FR'),
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const HomeShell(),
      ),
    );
  }
}
