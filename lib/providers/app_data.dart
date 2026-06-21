import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  double totalFocusHours = 0;
  int completedTasks = 0;

  // Method untuk update data dari Halaman Fokus
  void addFocusTime(double hours) {
    totalFocusHours += hours;
    notifyListeners(); // Memberitahu halaman Statistik untuk update UI
  }

  // Method untuk update dari Halaman Tugas
  void incrementCompletedTasks() {
    completedTasks++;
    notifyListeners();
  }
}
