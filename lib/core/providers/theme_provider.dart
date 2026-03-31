import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';
  final _storage = const FlutterSecureStorage();

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.light;
  }

  Future<void> _load() async {
    final val = await _storage.read(key: _key);
    state = val == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(key: _key, value: state == ThemeMode.dark ? 'dark' : 'light');
  }
}
