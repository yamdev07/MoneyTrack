import 'package:flutter/foundation.dart';

import '../data/profile_repository.dart';
import '../models/user_profile.dart';

/// Exposes the user profile (salary, currency) to the widget tree.
class ProfileController extends ChangeNotifier {
  ProfileController(this._repo);

  final ProfileRepository _repo;

  UserProfile get profile => _repo.getProfile();
  double get salary => profile.monthlySalary;
  String get currency => profile.currencyCode;
  bool get hasSalary => profile.hasSalary;

  Future<void> setSalary(double value) async {
    await _repo.setSalary(value);
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    await _repo.setCurrency(value);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, double? salary, String? currency}) async {
    final updated = profile.copyWith(
      name: name,
      monthlySalary: salary,
      currencyCode: currency,
    );
    await _repo.save(updated);
    notifyListeners();
  }
}
