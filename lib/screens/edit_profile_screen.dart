import 'package:flutter/material.dart';
import '../theme.dart';

class EditProfileScreen extends StatefulWidget {
  // Menerima data awal dari halaman Profil
  final String initialName;
  final String initialNim;
  final String initialEmail;
  final String initialUniv;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialNim,
    required this.initialEmail,
    required this.initialUniv,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _nimCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _univCtrl;

  @override
  void initState() {
    super.initState();
    // Mengisi kolom teks dengan data yang dikirim dari profil
    _nameCtrl = TextEditingController(text: widget.initialName);
    _nimCtrl = TextEditingController(text: widget.initialNim);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _univCtrl = TextEditingController(text: widget.initialUniv);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    _emailCtrl.dispose();
    _univCtrl.dispose();
    super.dispose();
  }

  // Logika untuk mengambil inisial untuk Avatar
  String _getInitials(String name) {
    String cleanName = name.replaceAll(RegExp(r'^M\.\s*'), '').trim();
    List<String> nameParts = cleanName.split(' ');
    if (nameParts.isEmpty || cleanName.isEmpty) return '?';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
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
          onPressed: () => Navigator.pop(context), // Kembali tanpa simpan
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- AVATAR EDIT ---
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Colors.purpleAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(_nameCtrl.text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Ubah Foto Profil',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'JPG, PNG maks. 2MB',
              style: TextStyle(color: AppColors.textGrey, fontSize: 10),
            ),
            const SizedBox(height: 32),

            // --- FORM INFORMASI PRIBADI ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'INFORMASI PRIBADI',
                style: TextStyle(
                  color: AppColors.textGrey.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    'Nama Lengkap',
                    _nameCtrl,
                    Icons.person_outline,
                    onChanged: (v) => setState(() {}),
                  ),
                  Divider(
                    color: AppColors.textGrey.withOpacity(0.1),
                    height: 32,
                  ),
                  _buildTextField('NIM / ID Mahasiswa', _nimCtrl, Icons.tag),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    'Email Kampus/Personal',
                    _emailCtrl,
                    Icons.mail_outline,
                  ),
                  Divider(
                    color: AppColors.textGrey.withOpacity(0.1),
                    height: 32,
                  ),
                  _buildTextField(
                    'Universitas / Institusi',
                    _univCtrl,
                    Icons.domain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- TOMBOL SIMPAN ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Mengirim data kembali ke halaman Profil dalam bentuk Map
                  Navigator.pop(context, {
                    'name': _nameCtrl.text,
                    'nim': _nimCtrl.text,
                    'email': _emailCtrl.text,
                    'univ': _univCtrl.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData suffixIcon, {
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged, // Untuk update inisial avatar secara realtime
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            border: InputBorder.none,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            suffixIcon: Icon(suffixIcon, color: AppColors.textGrey, size: 18),
          ),
        ),
      ],
    );
  }
}
