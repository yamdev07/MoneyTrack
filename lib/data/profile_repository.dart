import 'package:hive/hive.dart';

import '../core/app_constants.dart';
import '../models/user_profile.dart';

/// Persists the single [UserProfile] record.
class ProfileRepository {
  Box<UserProfile> get _box => Hive.box<UserProfile>(AppConstants.profileBox);

  UserProfile getProfile() =>
      _box.get(AppConstants.profileKey) ?? UserProfile.empty();

  Future<void> save(UserProfile profile) =>
      _box.put(AppConstants.profileKey, profile);

  Future<void> setSalary(double salary) async {
    final profile = getProfile()..monthlySalary = salary;
    await save(profile);
  }

  Future<void> setCurrency(String currency) async {
    final profile = getProfile()..currencyCode = currency;
    await save(profile);
  }

  bool get hasProfile => _box.containsKey(AppConstants.profileKey);
}
