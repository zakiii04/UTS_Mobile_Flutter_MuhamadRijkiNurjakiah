import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthProvider>().updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
    setState(() => _isEditing = false);
    CustomSnackbar.show(context,
        message: 'Profil berhasil diperbarui ✓', isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        final user = auth.currentUser;
        if (user == null) return const SizedBox.shrink();

        // Sync controllers when not editing
        if (!_isEditing) {
          _nameController.text = user.name;
          _emailController.text = user.email;
          _phoneController.text = user.phone;
          _addressController.text = user.address;
        }

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        'Profil Saya',
                        style: GoogleFonts.outfit(
                          color: AppColors.accentGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Icon(Icons.person_rounded,
                          color: AppColors.accentGreen, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Avatar & Name Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGreen.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(user.email,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.accentGreen.withOpacity(0.1),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.stars_rounded, color: AppColors.accentGreen, size: 12),
                                    SizedBox(width: 4),
                                    Text('Premium Member',
                                        style: TextStyle(
                                            color: AppColors.accentGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Edit Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Informasi Pribadi',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      GestureDetector(
                        onTap: () {
                          if (_isEditing) {
                            setState(() => _isEditing = false);
                          } else {
                            setState(() => _isEditing = true);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: _isEditing
                                ? null
                                : const LinearGradient(
                                    colors: [AppColors.accentGreen, AppColors.accentGreenLight]),
                            color: _isEditing ? AppColors.bgCard : null,
                            border: _isEditing
                                ? Border.all(color: AppColors.borderColor)
                                : null,
                          ),
                          child: Row(children: [
                            Icon(
                                _isEditing ? Icons.close_rounded : Icons.edit_rounded,
                                color: _isEditing ? AppColors.textSecondary : Colors.white,
                                size: 16),
                            const SizedBox(width: 6),
                            Text(
                                _isEditing ? 'Batal' : 'Edit Profil',
                                style: TextStyle(
                                    color: _isEditing
                                        ? AppColors.textSecondary
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Form
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(
                            label: 'Nama Lengkap',
                            controller: _nameController,
                            icon: Icons.person_outline_rounded,
                            enabled: _isEditing,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Nama tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'Email',
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            enabled: _isEditing,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                              if (!v.contains('@')) return 'Format email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'Nomor HP',
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                            hint: 'Masukkan nomor HP',
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'Alamat',
                            controller: _addressController,
                            icon: Icons.location_on_outlined,
                            enabled: _isEditing,
                            maxLines: 3,
                            hint: 'Masukkan alamat lengkap',
                          ),
                          if (_isEditing) ...[
                            const SizedBox(height: 24),
                            GradientButton(
                              text: 'Simpan Perubahan',
                              icon: Icons.save_rounded,
                              onPressed: _saveProfile,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Aktivitas Belanja',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _statItem('12', 'Pesanan', Icons.receipt_long_rounded)),
                            Expanded(child: _statItem('5', 'Diproses', Icons.local_shipping_rounded)),
                            Expanded(child: _statItem('7', 'Selesai', Icons.check_circle_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  GradientButton(
                    text: 'Keluar dari Akun',
                    icon: Icons.logout_rounded,
                    colors: const [AppColors.error, Color(0xFFEF5350)],
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomConfirmDialog(
                          title: 'Konfirmasi Keluar',
                          message: 'Apakah Anda yakin ingin keluar dari akun Tokopadia?',
                          onConfirm: () {
                            context.read<AuthProvider>().logout();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                            CustomSnackbar.show(context,
                                message: 'Berhasil keluar ✓', isSuccess: true);
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textHint, size: 18),
            filled: true,
            fillColor: enabled ? AppColors.bgCardLight : AppColors.bgCard,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _statItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.accentGreen.withOpacity(0.2),
                AppColors.accentGreenLight.withOpacity(0.1),
              ],
            ),
          ),
          child: Icon(icon, color: AppColors.accentGreen, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
