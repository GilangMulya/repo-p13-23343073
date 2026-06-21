import 'package:flutter/material.dart';
import 'stat_data.dart';
import 'notif_data.dart'; // Import memori notifikasi
import 'theme.dart';

class Task {
  final String id;
  String title;
  String? description;
  String category;
  String priority;
  double progress;
  DateTime? dueDate;
  int statusIndex;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    this.progress = 0.0,
    this.dueDate,
    this.statusIndex = 0,
  });
}

class AppTasks extends ChangeNotifier {
  static final AppTasks instance = AppTasks._internal();
  AppTasks._internal();

  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Setup Project Flutter',
      category: 'Dev',
      priority: 'High',
      progress: 0.65,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      statusIndex: 1,
    ),
  ];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void updateTaskStatus(String id, int newStatus) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      int oldStatus = tasks[index].statusIndex;
      tasks[index].statusIndex = newStatus;

      if (newStatus == 2) tasks[index].progress = 1.0;
      if (newStatus == 0) tasks[index].progress = 0.0;

      // JIKA TUGAS SELESAI -> CATAT KE STATISTIK & KIRIM NOTIFIKASI
      if (oldStatus != 2 && newStatus == 2) {
        AppStats.instance.addTask();
        AppNotifs.instance.addNotification(
          title: 'Tugas Diselesaikan',
          desc: 'Tugas "${tasks[index].title}" berhasil ditandai selesai.',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        );
      }
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateTaskDetail(Task updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      int oldStatus = tasks[index].statusIndex;
      tasks[index] = updatedTask;

      if (oldStatus != 2 && updatedTask.statusIndex == 2) {
        AppStats.instance.addTask();
        AppNotifs.instance.addNotification(
          title: 'Tugas Diselesaikan',
          desc: 'Tugas "${updatedTask.title}" berhasil ditandai selesai.',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        );
      }
      notifyListeners();
    }
  }
}
