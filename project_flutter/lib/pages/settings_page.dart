import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/common_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Row(
                      children: [
                        if (Navigator.canPop(context))
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.bgCard,
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: const Icon(Icons.arrow_back_ios_rounded,
                                  color: AppColors.textPrimary, size: 18),
                            ),
                          ),
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [AppColors.accentGreen, AppColors.accentGreenLight],
                          ).createShader(b),
                          child: const Text('Pengaturan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Preferences
                        _sectionTitle('Preferensi Aplikasi'),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _switchTile(
                                icon: Icons.dark_mode_rounded,
                                iconColor: AppColors.accentPurple,
                                title: 'Mode Gelap',
                                subtitle: 'Aktifkan tampilan dark mode',
                                value: auth.isDarkMode,
                                onChanged: (v) => auth.toggleDarkMode(),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.notifications_outlined,
                                iconColor: AppColors.accentBlue,
                                title: 'Notifikasi',
                                subtitle: 'Kelola notifikasi aplikasi',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Fitur segera hadir!'),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.language_rounded,
                                iconColor: AppColors.accentCyan,
                                title: 'Bahasa',
                                subtitle: 'Bahasa Indonesia',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Fitur segera hadir!'),
                                trailing: const Text('ID',
                                    style: TextStyle(
                                        color: AppColors.textSecondary, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Account
                        _sectionTitle('Akun'),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _tile(
                                icon: Icons.person_outline_rounded,
                                iconColor: AppColors.accentBlue,
                                title: 'Edit Profil',
                                subtitle: 'Ubah informasi akun Anda',
                                onTap: () => Navigator.pop(context),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.lock_outline_rounded,
                                iconColor: AppColors.accentPurple,
                                title: 'Keamanan',
                                subtitle: 'Password dan autentikasi',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Fitur segera hadir!'),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.privacy_tip_outlined,
                                iconColor: AppColors.accentCyan,
                                title: 'Privasi & Data',
                                subtitle: 'Kelola data pribadi Anda',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Fitur segera hadir!'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // About
                        _sectionTitle('Tentang'),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _tile(
                                icon: Icons.info_outline_rounded,
                                iconColor: AppColors.accentGreen,
                                title: 'Tentang Aplikasi',
                                subtitle: 'Tokopadia v1.0.0',
                                onTap: () => _showAboutDialog(context),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.star_outline_rounded,
                                iconColor: AppColors.accentGold,
                                title: 'Beri Rating',
                                subtitle: 'Nilai aplikasi kami di store',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Terima kasih atas dukungannya! ⭐'),
                              ),
                              const Divider(color: AppColors.borderColor, height: 1),
                              _tile(
                                icon: Icons.help_outline_rounded,
                                iconColor: AppColors.accentCyan,
                                title: 'Bantuan & FAQ',
                                subtitle: 'Pertanyaan yang sering diajukan',
                                onTap: () => CustomSnackbar.show(context,
                                    message: 'Fitur segera hadir!'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Logout
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context, auth),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.error.withOpacity(0.1),
                              border: Border.all(
                                  color: AppColors.error.withOpacity(0.3)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded,
                                    color: AppColors.error, size: 22),
                                SizedBox(width: 10),
                                Text('Keluar dari Akun',
                                    style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Version info
                        Center(
                          child: Text(
                            'Tokopadia v1.0.0\n© 2026 All Rights Reserved',
                            style: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5));
  }

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iconColor.withOpacity(0.15),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12)),
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentGreen,
            activeTrackColor: AppColors.accentGreen.withOpacity(0.3),
            inactiveThumbColor: AppColors.textHint,
            inactiveTrackColor: AppColors.bgCardLight,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => CustomConfirmDialog(
        title: 'Konfirmasi Keluar',
        message: 'Apakah Anda yakin ingin keluar dari akun Tokopadia?',
        onConfirm: () {
          auth.logout();
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          CustomSnackbar.show(context,
              message: 'Berhasil keluar ✓', isSuccess: true);
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                  colors: [AppColors.accentGreen, AppColors.accentGreenLight]),
            ),
            child: const Icon(Icons.devices_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Tokopadia',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versi: 1.0.0',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            SizedBox(height: 8),
            Text(
              'Tokopadia adalah platform belanja teknologi premium dengan pengalaman berbelanja yang modern dan menyenangkan.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
            SizedBox(height: 12),
            Text('© 2026 Tokopadia',
                style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('NIM: 2306044',
                style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup',
                style: TextStyle(color: AppColors.accentBlue)),
          ),
        ],
      ),
    );
  }
}
