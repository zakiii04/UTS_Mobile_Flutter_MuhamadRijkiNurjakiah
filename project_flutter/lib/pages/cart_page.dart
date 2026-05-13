import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (ctx, provider, _) {
            final cart = provider.cart;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        'Keranjang',
                        style: GoogleFonts.outfit(
                          color: AppColors.accentGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      if (cart.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: AppColors.bgCard,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text('Kosongkan Keranjang?',
                                    style: TextStyle(color: AppColors.textPrimary)),
                                content: const Text(
                                    'Semua produk di keranjang akan dihapus.',
                                    style: TextStyle(color: AppColors.textSecondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal',
                                        style: TextStyle(color: AppColors.textSecondary)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.clearCart();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Hapus',
                                        style: TextStyle(color: AppColors.error)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(Icons.delete_outline_rounded,
                              color: AppColors.error),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${provider.cartCount} produk',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: cart.isEmpty
                      ? const EmptyStateWidget(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Keranjang Kosong',
                          subtitle:
                              'Tambahkan produk ke keranjang untuk melanjutkan belanja',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: cart.length,
                          itemBuilder: (ctx, i) {
                            final item = cart[i];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(milliseconds: 300 + (i * 80)),
                              curve: Curves.easeOutCubic,
                              builder: (ctx, val, child) => Opacity(
                                opacity: val,
                                child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - val)),
                                    child: child),
                              ),
                              child: Dismissible(
                                key: Key(item.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppColors.error,
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete_rounded,
                                      color: Colors.white),
                                ),
                                onDismissed: (_) {
                                  provider.removeFromCart(item.id);
                                  CustomSnackbar.show(context,
                                      message: '${item.name} dihapus dari keranjang',
                                      isError: true);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.bgCard,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(color: AppColors.borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.accentGreen.withOpacity(0.15),
                                              AppColors.accentGreenLight.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          _getIcon(item.iconPath),
                                          color: AppColors.accentBlue,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.brand,
                                                style: const TextStyle(
                                                    color: AppColors.accentBlue,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600)),
                                            Text(item.name,
                                                style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 4),
                                            Text(
                                                AppUtils.formatCurrency(item.price),
                                                style: const TextStyle(
                                                    color: AppColors.accentGreen,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => provider
                                                  .decreaseQuantity(item.id),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(8)),
                                                child: const Icon(
                                                    Icons.remove_rounded,
                                                    color: AppColors.textSecondary,
                                                    size: 16),
                                              ),
                                            ),
                                            Container(
                                              width: 32,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  item.quantity.toString(),
                                                  style: const TextStyle(
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14)),
                                            ),
                                            GestureDetector(
                                              onTap: () => provider
                                                  .increaseQuantity(item.id),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    gradient: const LinearGradient(
                                                        colors: [
                                                          AppColors.accentGreen,
                                                          AppColors.accentGreenLight
                                                        ])),
                                                child: const Icon(
                                                    Icons.add_rounded,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cart.isNotEmpty) _buildCheckoutBar(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, ProductProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.borderColor)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, -8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran:',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text(
                AppUtils.formatCurrency(provider.cartTotal),
                style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GradientButton(
            text: 'Checkout (${provider.cartCount} item)',
            icon: Icons.payment_rounded,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.bgCard,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Row(children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 28),
                    SizedBox(width: 10),
                    Text('Pesanan Berhasil!',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
                  ]),
                  content: Text(
                    'Terima kasih! Pesanan senilai ${AppUtils.formatCurrency(provider.cartTotal)} telah dikonfirmasi.\n\nEkspektasi pengiriman: 2-3 hari kerja.',
                    style: const TextStyle(
                        color: AppColors.textSecondary, height: 1.5),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        provider.clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text('OK, Terima Kasih!',
                          style: TextStyle(color: AppColors.accentBlue,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String p) {
    switch (p) {
      case 'smartphone': return Icons.smartphone_rounded;
      case 'laptop': return Icons.laptop_rounded;
      case 'headphones': return Icons.headphones_rounded;
      case 'watch': return Icons.watch_rounded;
      case 'camera': return Icons.camera_alt_rounded;
      case 'tablet': return Icons.tablet_mac_rounded;
      default: return Icons.devices_rounded;
    }
  }
}
