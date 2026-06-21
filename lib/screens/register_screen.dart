import 'package:flutter/material.dart';
import '../theme.dart';
import '../auth_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- PRE-FILL DATA OTOMATIS ---
  final _nameCtrl = TextEditingController(text: 'M. Gilang Mulya Putra');
  final _emailCtrl = TextEditingController(text: 'gilang.putra@kampus.ac.id');
  final _passCtrl = TextEditingController(text: 'Gilang123!');
  final _confirmPassCtrl = TextEditingController(text: 'Gilang123!');

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  void _handleRegister() {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua bidang!'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak cocok!'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // Simpan ke memori sementara
    AuthData.instance.register(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil! Silakan Login.'),
        backgroundColor: AppColors.success,
      ),
    );

    // --- KIRIM DATA KEMBALI KE HALAMAN LOGIN ---
    Navigator.pop(context, {
      'email': _emailCtrl.text,
      'password': _passCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Daftar Akun Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer penyeimbang
                ],
              ),
              const SizedBox(height: 32),

              // --- ICON PROFILE ---
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Buat akun baru untuk memulai',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- FORM ---
              _buildInputLabel('NAMA LENGKAP', Icons.person_outline),
              _buildTextField(
                'Masukkan nama lengkap anda',
                Icons.person_outline,
                _nameCtrl,
              ),
              const SizedBox(height: 16),

              _buildInputLabel('EMAIL', Icons.mail_outline),
              _buildTextField(
                'Masukkan email anda',
                Icons.mail_outline,
                _emailCtrl,
              ),
              const SizedBox(height: 16),

              _buildInputLabel('PASSWORD', Icons.lock_outline),
              _buildTextField(
                'Buat password anda',
                Icons.lock_outline,
                _passCtrl,
                isPassword: true,
                obscure: _obscurePass,
                onToggleObscure: () =>
                    setState(() => _obscurePass = !_obscurePass),
              ),
              const SizedBox(height: 16),

              _buildInputLabel(
                'KONFIRMASI PASSWORD',
                Icons.verified_user_outlined,
              ),
              _buildTextField(
                'Ulangi password anda',
                Icons.verified_user_outlined,
                _confirmPassCtrl,
                isPassword: true,
                obscure: _obscureConfirmPass,
                onToggleObscure: () =>
                    setState(() => _obscureConfirmPass = !_obscureConfirmPass),
              ),
              const SizedBox(height: 16),

              // --- PASSWORD SYARAT BOX ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textGrey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Password harus memenuhi syarat:',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildReqText('Minimal 8 karakter'),
                    _buildReqText('Kombinasi huruf besar & kecil'),
                    _buildReqText('Mengandung angka atau simbol'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- BUTTON DAFTAR ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _handleRegister,
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Buat Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- FOOTER ---
              const Center(
                child: Text(
                  'Dengan mendaftar, kamu menyetujui Syarat & Ketentuan\ndan Kebijakan Privasi kami.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 10),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReqText(String text) => Padding(
    padding: const EdgeInsets.only(left: 22, bottom: 4),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textGrey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textGrey.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    ),
  );

  Widget _buildInputLabel(String text, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    ),
  );

  Widget _buildTextField(
    String hint,
    IconData prefixIcon,
    TextEditingController controller, {
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        filled: true,
        fillColor: AppColors.cardDark,
        prefixIcon: Icon(prefixIcon, color: AppColors.textGrey, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
