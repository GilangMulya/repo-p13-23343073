import 'package:flutter/material.dart';
import '../theme.dart';
import '../stat_data.dart';
import '../settings_data.dart';
import 'dart:math';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});
  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  String _selectedFilter = 'Mingguan';
  final List<String> _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    // --- BUNGKUS DENGAN LISTENER TEMA ---
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isDarkMode,
      builder: (context, isDark, child) {
        Color bgColor = isDark
            ? const Color(0xFF0D0E15)
            : const Color(0xFFFFFFFF);
        Color cardColor = isDark ? AppColors.cardDark : const Color(0xFFF8F9FA);
        Color textColor = isDark ? Colors.white : const Color(0xFF1E1F29);
        Color subTextColor = isDark
            ? AppColors.textGrey
            : const Color(0xFF6C6D75);

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: ListenableBuilder(
              listenable: AppStats.instance,
              builder: (context, child) {
                final stats = AppStats.instance;
                String totalJam = (stats.totalFocusMinutes / 60)
                    .toStringAsFixed(1);
                if (totalJam.endsWith('.0'))
                  totalJam = totalJam.substring(0, totalJam.length - 2);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Statistik Fokus',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ringkasan aktivitas minggu ini',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                          _buildDropdown(cardColor, textColor, subTextColor),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildSummaryCard(
                            title: 'Total Fokus',
                            value: '$totalJam Jam',
                            subtext: 'Minggu ini',
                            icon: Icons.access_time,
                            color: AppColors.primary,
                            isTrendUp: true,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(width: 16),
                          _buildSummaryCard(
                            title: 'Tugas Selesai',
                            value: '${stats.totalTasksCompleted} Tugas',
                            subtext: '${stats.totalSessions} Pomodoro',
                            icon: Icons.check_circle_outline,
                            color: AppColors.success,
                            isTrendUp: true,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Minggu Ini',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Periode Berjalan',
                                      style: TextStyle(
                                        color: subTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildCustomBarChart(
                              stats.weeklyData,
                              textColor,
                              subTextColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildHighlightCard(
                            title: 'Total Sesi',
                            value: '${stats.totalSessions} Sesi',
                            subtext: 'Pomodoro',
                            icon: Icons.timer_outlined,
                            color: Colors.orangeAccent,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(width: 12),
                          _buildHighlightCard(
                            title: 'Hari Terbaik',
                            value: stats.bestDay,
                            subtext: 'Tertinggi',
                            icon: Icons.star_border,
                            color: Colors.orangeAccent,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(width: 12),
                          _buildHighlightCard(
                            title: 'Streak',
                            value: '${stats.streakDays} Hari',
                            subtext: 'Berturut-turut',
                            icon: Icons.local_fire_department_outlined,
                            color: AppColors.danger,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Sesi Terakhir',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (stats.recentSessions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'Belum ada sesi fokus yang diselesaikan.',
                              style: TextStyle(
                                color: subTextColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      else
                        ...stats.recentSessions
                            .map(
                              (session) => _buildRecentSessionItem(
                                session['title']!,
                                session['subtitle']!,
                                session['duration']!,
                                AppColors.primary,
                                cardColor,
                                textColor,
                                subTextColor,
                              ),
                            )
                            .toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: subTextColor.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          dropdownColor: cardColor,
          icon: Icon(Icons.keyboard_arrow_down, color: subTextColor, size: 20),
          style: TextStyle(color: textColor, fontSize: 12),
          onChanged: (v) => setState(() => _selectedFilter = v!),
          items: [
            'Mingguan',
            'Bulanan',
            'Tahunan',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required bool isTrendUp,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: subTextColor, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtext,
              style: TextStyle(
                color: isTrendUp ? AppColors.success : subTextColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: subTextColor, fontSize: 9)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              style: TextStyle(color: subTextColor, fontSize: 9),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessionItem(
    String title,
    String subtitle,
    String duration,
    Color color,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.timer, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: subTextColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Text(
            duration,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBarChart(
    List<double> data,
    Color textColor,
    Color subTextColor,
  ) {
    double maxData = data.reduce(max);
    if (maxData < 1.0) maxData = 1.0;
    return SizedBox(
      height: 220.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          double value = data[index];
          double barHeight = (value / maxData) * 150.0;
          int todayIndex = DateTime.now().weekday - 1;
          bool isActive = index == todayIndex;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (value > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${value.toStringAsFixed(1)}j',
                    style: TextStyle(
                      color: isActive ? textColor : subTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
              else
                const SizedBox(height: 22),
              Container(
                width: 32,
                height: barHeight == 0 ? 4 : barHeight,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: isActive
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                    : EdgeInsets.zero,
                decoration: isActive
                    ? BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Text(
                  _days[index],
                  style: TextStyle(
                    color: isActive ? AppColors.primary : subTextColor,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
