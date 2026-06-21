import 'package:flutter/material.dart';

class NotifItem {
  final String id;
  final String title;
  final String desc;
  final DateTime time;
  bool isRead;
  final IconData icon;
  final Color color;

  NotifItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    this.isRead = false,
    required this.icon,
    required this.color,
  });

  // Format waktu otomatis (Contoh: 08:20 PM)
  String get formattedTime {
    String h = (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(
      2,
      '0',
    );
    String m = time.minute.toString().padLeft(2, '0');
    String p = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }
}

class AppNotifs extends ChangeNotifier {
  static final AppNotifs instance = AppNotifs._internal();
  AppNotifs._internal();

  List<NotifItem> notifications = [];

  // Menghitung jumlah notifikasi yang belum dibaca
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  // Menambah notifikasi baru
  void addNotification({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    notifications.insert(
      0,
      NotifItem(
        id: DateTime.now().toString(),
        title: title,
        desc: desc,
        time: DateTime.now(),
        icon: icon,
        color: color,
      ),
    );
    notifyListeners();
  }

  // Tandai semua sudah dibaca (dipanggil saat keluar dari halaman notifikasi)
  void markAllAsRead() {
    for (var notif in notifications) {
      notif.isRead = true;
    }
    notifyListeners();
  }
}
