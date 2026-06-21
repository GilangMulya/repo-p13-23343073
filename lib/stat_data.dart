import 'package:flutter/material.dart';

class AppStats extends ChangeNotifier {
  static final AppStats instance = AppStats._internal();
  AppStats._internal();

  // Data Statistik Inti
  int totalFocusMinutes = 0;
  int totalTasksCompleted = 0;
  int totalSessions = 0;

  // Data grafik mingguan (Senin - Minggu)
  List<double> weeklyData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<Map<String, String>> recentSessions = [];

  // --- LOGIKA STREAK REAL-TIME ---
  int streakDays = 0;
  DateTime? lastActiveDate;

  void _checkAndUpdateStreak() {
    final now = DateTime.now();
    // Normalisasi waktu ke jam 00:00:00 agar hitungannya murni per hari
    final today = DateTime(now.year, now.month, now.day);

    if (lastActiveDate == null) {
      // Aktivitas pertama kali
      streakDays = 1;
      lastActiveDate = today;
    } else {
      final difference = today.difference(lastActiveDate!).inDays;
      if (difference == 1) {
        // Aktif di hari berturut-turut
        streakDays += 1;
        lastActiveDate = today;
      } else if (difference > 1) {
        // Terlewat lebih dari 1 hari, Streak hangus/reset
        streakDays = 1;
        lastActiveDate = today;
      }
      // Jika difference == 0 (masih di hari yang sama), abaikan (streak tidak bertambah)
    }
  }

  // --- LOGIKA HARI TERBAIK ---
  String get bestDay {
    double maxVal = 0;
    int bestIndex = -1;

    // Mencari index dengan nilai tertinggi di dalam array grafik
    for (int i = 0; i < weeklyData.length; i++) {
      if (weeklyData[i] > maxVal) {
        maxVal = weeklyData[i];
        bestIndex = i;
      }
    }

    // Jika belum ada aktivitas sama sekali
    if (bestIndex == -1 || maxVal == 0) return '-';

    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[bestIndex];
  }

  // Fungsi untuk dipanggil saat TIMER POMODORO SELESAI
  void addSession(int minutes, String sessionName) {
    totalFocusMinutes += minutes;
    totalSessions += 1;

    // Mendapatkan index hari ini secara otomatis (Senin=0, ... Jumat=4, dst)
    int todayIndex = DateTime.now().weekday - 1;
    weeklyData[todayIndex] += (minutes / 60.0);

    // Menambah riwayat sesi terbaru
    recentSessions.insert(0, {
      'title': 'Sesi Fokus',
      'subtitle': sessionName,
      'duration': '${minutes}m',
    });

    if (recentSessions.length > 5) {
      recentSessions.removeLast();
    }

    _checkAndUpdateStreak(); // Memicu hitungan kalender streak
    notifyListeners(); // Merender ulang UI
  }

  // Fungsi untuk dipanggil saat TUGAS DICENTANG SELESAI
  void addTask() {
    totalTasksCompleted += 1;
    _checkAndUpdateStreak(); // Memicu hitungan kalender streak
    notifyListeners();
  }
}
