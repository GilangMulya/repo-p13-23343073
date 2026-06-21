import 'package:flutter/material.dart';

class AppSettings {
  static ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(true);
  static ValueNotifier<bool> notifSesi = ValueNotifier<bool>(true);
  static ValueNotifier<bool> suaraTimer = ValueNotifier<bool>(true);
  static ValueNotifier<bool> getaran = ValueNotifier<bool>(false);

  static ValueNotifier<int> focusMins = ValueNotifier<int>(25);
  static ValueNotifier<int> shortBreakMins = ValueNotifier<int>(5);
  static ValueNotifier<int> longBreakMins = ValueNotifier<int>(15);
}
