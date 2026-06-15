import 'package:flutter/material.dart';

/// Root widget of the MoneyTrack application.
///
/// Wiring (theme, providers, routes) is added incrementally on top of this
/// minimal shell as features land.
class MoneyTrackApp extends StatelessWidget {
  const MoneyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyTrack',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('MoneyTrack')),
      ),
    );
  }
}
