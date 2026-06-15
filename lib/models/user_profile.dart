import 'package:hive/hive.dart';

/// The single app user (the cahier de charge is single-user for the MVP).
class UserProfile extends HiveObject {
  UserProfile({
    required this.name,
    required this.monthlySalary,
    this.currencyCode = 'FCFA',
  });

  /// Display name.
  String name;

  /// Monthly salary in [currencyCode].
  double monthlySalary;

  /// Currency label shown next to amounts (e.g. FCFA, €, $).
  String currencyCode;

  bool get hasSalary => monthlySalary > 0;

  UserProfile copyWith({
    String? name,
    double? monthlySalary,
    String? currencyCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  static UserProfile empty() => UserProfile(name: '', monthlySalary: 0);
}
