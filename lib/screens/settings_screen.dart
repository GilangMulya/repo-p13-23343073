import 'package:flutter/material.dart';
import '../theme.dart';
import '../settings_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = AppSettings.isDarkMode.value;

    // Sistem Pewarnaan Dinamis (Membaca State Tema)
    Color bgColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFFFFFFF);
    Color cardColor = isDark ? AppColors.cardDark : const Color(0xFFF8F9FA);
    Color textColor = isDark ? Colors.white : const Color(0xFF1E1F29);
    Color subTextColor = isDark ? AppColors.textGrey : const Color(0xFF6C6D75);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pengaturan',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TAMPILAN',
              style: TextStyle(
                color: subTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // --- BOX TEMA ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: subTextColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.desktop_windows,
                          color: subTextColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tema Aplikasi',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pilih tampilan yang nyaman',
                            style: TextStyle(color: subTextColor, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0D0E15)
                          : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Tombol Terang
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                              () => AppSettings.isDarkMode.value = false,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isDark
                                    ? const Color(0xFFFFFFFF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: !isDark
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wb_sunny_outlined,
                                    size: 16,
                                    color: !isDark
                                        ? AppColors.primary
                                        : subTextColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terang',
                                    style: TextStyle(
                                      color: !isDark
                                          ? AppColors.primary
                                          : subTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Tombol Gelap
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                              () => AppSettings.isDarkMode.value = true,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.nightlight_round,
                                    size: 16,
                                    color: isDark ? Colors.white : subTextColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Gelap',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : subTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'NOTIFIKASI',
              style: TextStyle(
                color: subTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    Icons.notifications_active,
                    'Notifikasi Sesi',
                    'Pengingat mulai & selesai',
                    Colors.orangeAccent,
                    AppSettings.notifSesi.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.notifSesi.value = v),
                  ),
                  Divider(
                    color: subTextColor.withOpacity(0.1),
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                  ),
                  _buildSwitchRow(
                    Icons.volume_up,
                    'Suara Timer',
                    'Bunyi notifikasi sesi',
                    Colors.blueAccent,
                    AppSettings.suaraTimer.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.suaraTimer.value = v),
                  ),
                  Divider(
                    color: subTextColor.withOpacity(0.1),
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                  ),
                  _buildSwitchRow(
                    Icons.vibration,
                    'Getaran',
                    'Getar saat sesi selesai',
                    AppColors.success,
                    AppSettings.getaran.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.getaran.value = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'TIMER & FOKUS',
              style: TextStyle(
                color: subTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildTimerControlRow(
                    Icons.timer,
                    'Durasi Fokus',
                    'Waktu sesi Pomodoro',
                    AppColors.primary,
                    AppSettings.focusMins.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.focusMins.value = v),
                  ),
                  Divider(
                    color: subTextColor.withOpacity(0.1),
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                  ),
                  _buildTimerControlRow(
                    Icons.local_cafe,
                    'Istirahat Pendek',
                    'Jeda antar sesi',
                    AppColors.success,
                    AppSettings.shortBreakMins.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.shortBreakMins.value = v),
                  ),
                  Divider(
                    color: subTextColor.withOpacity(0.1),
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                  ),
                  _buildTimerControlRow(
                    Icons.airline_seat_flat,
                    'Istirahat Panjang',
                    'Setelah 4 sesi selesai',
                    Colors.orange,
                    AppSettings.longBreakMins.value,
                    textColor,
                    subTextColor,
                    (v) => setState(() => AppSettings.longBreakMins.value = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    bool value,
    Color tColor,
    Color sColor,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: tColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: sColor, fontSize: 10)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerControlRow(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    int value,
    Color tColor,
    Color sColor,
    Function(int) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: tColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: sColor, fontSize: 10)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppSettings.isDarkMode.value
                  ? AppColors.background
                  : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (value > 1) onChanged(value - 1);
                  },
                  child: Icon(Icons.remove, color: sColor, size: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  '${value}m',
                  style: TextStyle(color: tColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => onChanged(value + 1),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
