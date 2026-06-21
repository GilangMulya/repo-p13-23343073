import 'package:flutter/material.dart';
import '../theme.dart';
import '../notif_data.dart'; // Import memori notifikasi

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedTab = 'Semua';

  @override
  void dispose() {
    // --- PERBAIKAN FATAL ---
    // Gunakan Future.microtask untuk menunda pembaruan status "dibaca"
    // sampai proses penutupan layar (dispose) ini benar-benar selesai.
    Future.microtask(() {
      AppNotifs.instance.markAllAsRead();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: InkWell(
                onTap: () => AppNotifs.instance.markAllAsRead(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.done_all, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Tandai dibaca',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: AppNotifs.instance,
        builder: (context, child) {
          final allNotifs = AppNotifs.instance.notifications;

          List<NotifItem> displayedNotifs = allNotifs;
          if (_selectedTab == 'Belum Dibaca')
            displayedNotifs = allNotifs.where((n) => !n.isRead).toList();
          if (_selectedTab == 'Sudah Dibaca')
            displayedNotifs = allNotifs.where((n) => n.isRead).toList();

          final unreadNotifs = displayedNotifs.where((n) => !n.isRead).toList();
          final readNotifs = displayedNotifs.where((n) => n.isRead).toList();

          return Column(
            children: [
              // TABS
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Row(
                  children: ['Semua', 'Belum Dibaca', 'Sudah Dibaca']
                      .map(
                        (tab) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTab = tab),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedTab == tab
                                    ? AppColors.primary
                                    : AppColors.cardDark,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  color: _selectedTab == tab
                                      ? Colors.white
                                      : AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              Expanded(
                child: displayedNotifs.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada notifikasi.',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (unreadNotifs.isNotEmpty) ...[
                            const Text(
                              'BARU',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...unreadNotifs.map((n) => _buildNotifCard(n)),
                            const SizedBox(height: 24),
                          ],

                          if (readNotifs.isNotEmpty) ...[
                            const Text(
                              'SEBELUMNYA',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...readNotifs.map((n) => _buildNotifCard(n)),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotifCard(NotifItem notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: !notif.isRead
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: notif.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(notif.icon, color: notif.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!notif.isRead)
                      const Icon(
                        Icons.circle,
                        color: AppColors.primary,
                        size: 8,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notif.desc,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors.textGrey,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notif.formattedTime,
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    if (!notif.isRead)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Baru',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
