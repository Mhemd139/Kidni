import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLang { he, ar }

/// Holds the app's current language and persists the choice.
/// Default is Hebrew. Exposed as a ValueNotifier so the app rebuilds on change.
class LanguageController {
  static const String _key = 'app_language';

  static final LanguageController instance = LanguageController._();
  LanguageController._();

  final ValueNotifier<AppLang> lang = ValueNotifier<AppLang>(AppLang.he);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == 'ar') lang.value = AppLang.ar;
  }

  Future<void> setLang(AppLang value) async {
    lang.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value == AppLang.ar ? 'ar' : 'he');
  }

  void toggle() {
    setLang(lang.value == AppLang.he ? AppLang.ar : AppLang.he);
  }

  AppLang get current => lang.value;
}
