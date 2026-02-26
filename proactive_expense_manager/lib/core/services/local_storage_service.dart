import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyToken = 'auth_token';
  static const _keyNickname = 'nickname';
  static const _keyPhone = 'phone';
  static const _keyBudgetLimit = 'budget_limit';
  static const _keyOnboardingDone = 'onboarding_done';

  final SharedPreferences _prefs;

  late final ValueNotifier<double> budgetLimitNotifier;
  late final ValueNotifier<String> nicknameNotifier;

  LocalStorageService(this._prefs) {
    budgetLimitNotifier = ValueNotifier(getBudgetLimit());
    nicknameNotifier = ValueNotifier(getNickname() ?? '');
  }

  // ── Auth ────────────────────────────────────────────────────────────────────

  Future<void> saveToken(String token) async =>
      _prefs.setString(_keyToken, token);

  Future<String?> getToken() async => _prefs.getString(_keyToken);

  Future<void> saveNickname(String nickname) async {
    await _prefs.setString(_keyNickname, nickname);
    nicknameNotifier.value = nickname;
  }

  String? getNickname() => _prefs.getString(_keyNickname);

  Future<void> savePhone(String phone) async =>
      _prefs.setString(_keyPhone, phone);

  String? getPhone() => _prefs.getString(_keyPhone);

  bool isLoggedIn() {
    final token = _prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAuth() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyNickname);
    await _prefs.remove(_keyPhone);
  }

  // ── Budget Limit ─────────────────────────────────────────────────────────

  Future<void> saveBudgetLimit(double amount) async {
    await _prefs.setDouble(_keyBudgetLimit, amount);
    budgetLimitNotifier.value = amount;
  }

  double getBudgetLimit() => _prefs.getDouble(_keyBudgetLimit) ?? 1000.0;

  // ── Onboarding ────────────────────────────────────────────────────────────

  Future<void> setOnboardingDone() async =>
      _prefs.setBool(_keyOnboardingDone, true);

  bool isOnboardingDone() => _prefs.getBool(_keyOnboardingDone) ?? false;
}
