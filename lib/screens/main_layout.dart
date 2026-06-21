import 'package:flutter/material.dart';
import '../theme.dart';
import '../settings_data.dart'; // Import pusat memori pengaturan
import 'task_screen.dart';
import 'focus_screen.dart';
import 'stat_screen.dart';
import 'profile_screen.dart';
import '../notif_data.dart'; // Import memori notifikasi

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const TaskScreen(),
    const FocusScreen(),
    const StatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isDarkMode,
      builder: (context, isDark, child) {
        Color currentBg = isDark
            ? AppColors.background
            : const Color(0xFFF3F4F6);
        Color currentNavBg = isDark ? AppColors.cardDark : Colors.white;
        Color currentUnselectedIcon = isDark
            ? AppColors.textGrey
            : const Color(0xFF9CA3AF);

        return Scaffold(
          backgroundColor: currentBg,

          // 🔥 INI ADALAH KUNCI UTAMANYA 🔥
          // IndexedStack akan menumpuk semua layar secara gaib di memori.
          // Jadi layarnya cuma "disembunyikan", bukan dihancurkan.
          body: IndexedStack(index: _currentIndex, children: _pages),

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: currentNavBg,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: currentUnselectedIcon,
              showUnselectedLabels: true,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outlined),
                  label: 'Tugas',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: 'Fokus',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Statistik',
                ),
                // TITIK MERAH NOTIFIKASI DI PROFIL
                BottomNavigationBarItem(
                  icon: ListenableBuilder(
                    listenable: AppNotifs.instance,
                    builder: (context, child) {
                      bool hasUnread = AppNotifs.instance.unreadCount > 0;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.person_outline),
                          if (hasUnread)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
