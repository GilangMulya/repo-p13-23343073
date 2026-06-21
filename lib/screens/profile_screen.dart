import 'package:flutter/material.dart';
import '../theme.dart';
import '../notif_data.dart';
import '../settings_data.dart'; // Import setting untuk tema
import 'edit_profile_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart'; // Import untuk fungsi logout

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'M. Gilang Mulya Putra';
  String _nim = '23343073';
  String _email = 'gilang.putra@kampus.ac.id';
  String _univ = 'Universitas Negeri Padang';

  String _getInitials(String name) {
    String cleanName = name.replaceAll(RegExp(r'^M\.\s*'), '').trim();
    List<String> nameParts = cleanName.split(' ');
    if (nameParts.isEmpty || cleanName.isEmpty) return '?';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // --- LISTENER TEMA ---
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
            child: SingleChildScrollView(
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
                      Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.more_horiz, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    Colors.purpleAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(_name),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    color: AppColors.success,
                                    size: 8,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Online',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _univ,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: $_nim  •  $_email',
                          style: TextStyle(color: subTextColor, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.success.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.workspace_premium,
                                color: AppColors.success,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Pro Member',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(color: subTextColor.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProfileStat(
                              '74',
                              'Total Jam',
                              textColor,
                              subTextColor,
                            ),
                            _buildDivider(subTextColor),
                            _buildProfileStat(
                              '148',
                              'Total Sesi',
                              textColor,
                              subTextColor,
                            ),
                            _buildDivider(subTextColor),
                            _buildProfileStat(
                              '5 🔥',
                              'Hari Streak',
                              textColor,
                              subTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'AKUN',
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
                        _buildMenuRow(
                          icon: Icons.person_outline,
                          title: 'Edit Profil',
                          subtitle: 'Ubah nama, foto, dan info',
                          iconColor: AppColors.primary,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  initialName: _name,
                                  initialNim: _nim,
                                  initialEmail: _email,
                                  initialUniv: _univ,
                                ),
                              ),
                            );
                            if (result != null &&
                                result is Map<String, String>) {
                              setState(() {
                                _name = result['name'] ?? _name;
                                _nim = result['nim'] ?? _nim;
                                _email = result['email'] ?? _email;
                                _univ = result['univ'] ?? _univ;
                              });
                            }
                          },
                        ),
                        _buildDividerHorizontal(subTextColor),
                        ListenableBuilder(
                          listenable: AppNotifs.instance,
                          builder: (context, child) {
                            int unread = AppNotifs.instance.unreadCount;
                            return _buildMenuRow(
                              icon: Icons.notifications_none,
                              title: 'Notifikasi',
                              subtitle: 'Kelola preferensi notifikasi',
                              iconColor: Colors.orangeAccent,
                              textColor: textColor,
                              subTextColor: subTextColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              ),
                              trailing: unread > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.danger.withOpacity(
                                          0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.danger.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: AppColors.danger,
                                            size: 6,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$unread Baru',
                                            style: const TextStyle(
                                              color: AppColors.danger,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                        _buildDividerHorizontal(subTextColor),
                        _buildMenuRow(
                          icon: Icons.tune,
                          title: 'Pengaturan',
                          subtitle: 'Tema, bahasa, dan privasi',
                          iconColor: subTextColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'LAINNYA',
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
                        _buildMenuRow(
                          icon: Icons.help_outline,
                          title: 'Bantuan & Dukungan',
                          subtitle: 'FAQ dan hubungi kami',
                          iconColor: Colors.lightBlue,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () {},
                        ),
                        InkWell(
                          // --- FITUR LOGOUT ---
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) =>
                                  false, // Membuang semua history halaman
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.logout,
                                  color: AppColors.danger,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Keluar',
                                  style: TextStyle(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileStat(
    String value,
    String label,
    Color textColor,
    Color subTextColor,
  ) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: subTextColor, fontSize: 10)),
    ],
  );
  Widget _buildDivider(Color subTextColor) =>
      Container(height: 30, width: 1, color: subTextColor.withOpacity(0.2));
  Widget _buildDividerHorizontal(Color subTextColor) => Divider(
    height: 1,
    color: subTextColor.withOpacity(0.1),
    indent: 64,
    endIndent: 24,
  );

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color textColor,
    required Color subTextColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: subTextColor, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (trailing != null) const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: subTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}
