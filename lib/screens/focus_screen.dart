import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../settings_data.dart';
import '../stat_data.dart';
import '../notif_data.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});
  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int _sessionMode = 0;
  late int _timeLeft;
  bool _isRunning = false;
  bool _isPaused = false;
  int _currentSession = 1;
  final int _maxSessions = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = AppSettings.focusMins.value * 60;
  }

  int get _totalDuration {
    if (_sessionMode == 0) return AppSettings.focusMins.value * 60;
    if (_sessionMode == 1) return AppSettings.shortBreakMins.value * 60;
    return AppSettings.longBreakMins.value * 60;
  }

  String get _formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress => max(0.0, min(1.0, 1 - (_timeLeft / _totalDuration)));
  double max(double a, double b) => a > b ? a : b;
  double min(double a, double b) => a < b ? a : b;

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleSessionComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _timeLeft = _totalDuration;
    });
  }

  void _skipSession() {
    _timer?.cancel();
    _handleSessionComplete();
  }

  void _handleSessionComplete() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = false;
      if (_sessionMode == 0) {
        _triggerHardwareSimulation("Sesi Fokus Selesai!");
        AppStats.instance.addSession(
          AppSettings.focusMins.value,
          'Mengerjakan Tugas Kuliah',
        );
        AppNotifs.instance.addNotification(
          title: 'Sesi Fokus Selesai!',
          desc: 'Kamu berhasil menyelesaikan 1 sesi Pomodoro. Kerja bagus!',
          icon: Icons.timer,
          color: Colors.orange,
        );
        if (_currentSession == _maxSessions) {
          _sessionMode = 2;
          _timeLeft = AppSettings.longBreakMins.value * 60;
        } else {
          _sessionMode = 1;
          _timeLeft = AppSettings.shortBreakMins.value * 60;
        }
      } else {
        _triggerHardwareSimulation("Waktu Istirahat Habis! Ayo Fokus Lagi.");
        if (_sessionMode == 2) _currentSession = 1;
        if (_sessionMode == 1) _currentSession++;
        _sessionMode = 0;
        _timeLeft = AppSettings.focusMins.value * 60;
      }
    });
  }

  void _triggerHardwareSimulation(String message) {
    List<String> effects = [];
    if (AppSettings.notifSesi.value) effects.add("🔔 [Push Notif]");
    if (AppSettings.suaraTimer.value) effects.add("🔊 [Alarm Ringing]");
    if (AppSettings.getaran.value) effects.add("📳 [Device Vibrating]");
    String effectLog = effects.isEmpty ? "🔇 [Silent Mode]" : effects.join(" ");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.orangeAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    effectLog,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

        Color activeColor = _isPaused
            ? AppColors.danger
            : (_sessionMode == 0 ? AppColors.primary : AppColors.success);
        String modeLabel = _sessionMode == 0
            ? 'POMODORO'
            : (_sessionMode == 1 ? 'ISTIRAHAT PENDEK' : 'ISTIRAHAT PANJANG');

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sesi Fokus',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hindari gangguan, tetap fokus.',
                            style: TextStyle(fontSize: 14, color: subTextColor),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.tune, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoChip(
                        'Sesi $_currentSession dari $_maxSessions',
                        _sessionMode == 0,
                        AppColors.primary,
                        cardColor,
                        textColor,
                        subTextColor,
                        Icons.layers_outlined,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        _sessionMode == 2
                            ? 'Istirahat Panjang'
                            : 'Istirahat ${AppSettings.shortBreakMins.value}m',
                        _sessionMode > 0,
                        AppColors.success,
                        cardColor,
                        textColor,
                        subTextColor,
                        Icons.local_cafe_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withOpacity(0.25),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 8,
                            color: cardColor,
                          ),
                        ),
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 8,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              activeColor,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formattedTime,
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              modeLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _sessionMode > 0
                                    ? AppColors.success
                                    : subTextColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            if (_isPaused) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: AppColors.danger,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'DIJEDA',
                                    style: TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 54),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _resetTimer,
                        icon: Icon(
                          Icons.refresh,
                          color: subTextColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: _isRunning ? _pauseTimer : _startTimer,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _isRunning
                                ? AppColors.danger
                                : AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isRunning
                                            ? AppColors.danger
                                            : AppColors.primary)
                                        .withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: _skipSession,
                        icon: Icon(
                          Icons.skip_next,
                          color: subTextColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isPaused
                          ? AppColors.danger.withOpacity(0.1)
                          : cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: _isPaused
                          ? Border.all(color: AppColors.danger.withOpacity(0.5))
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isPaused ? Icons.info_outline : Icons.bolt,
                          color: _isPaused
                              ? AppColors.danger
                              : Colors.orangeAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isPaused
                              ? 'Timer dijeda — lanjutkan saat siap!'
                              : 'Matikan notifikasi untuk hasil terbaik',
                          style: TextStyle(
                            color: _isPaused ? AppColors.danger : subTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(
    String text,
    bool isActive,
    Color color,
    Color cColor,
    Color tColor,
    Color sColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? color : sColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isActive ? color : sColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isActive ? color : sColor,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
