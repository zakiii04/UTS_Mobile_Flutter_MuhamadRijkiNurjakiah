import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Consumer<ProductProvider>(
      builder: (ctx, provider, _) {
        final isFav = provider.isFavorite(p.id);
        final inCart = provider.isInCart(p.id);
        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.bgPrimary,
                surfaceTintColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => provider.toggleFavorite(p),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? AppColors.error : AppColors.textMuted, size: 22),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${p.id}',
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.meshGradient,
                      ),
                      child: Center(
                        child: Icon(_getIcon(p.iconPath), size: 140,
                            color: AppColors.accentBlue.withOpacity(0.8)),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _badge(p.brand, gradient: true),
                              const SizedBox(width: 8),
                              _badge(p.category),
                              const Spacer(),
                              if (p.isNew) _badge('✦ NEW', success: true),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(p.name,
                              style: const TextStyle(color: AppColors.textPrimary,
                                  fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (b) => const LinearGradient(
                                        colors: [AppColors.accentGreen, AppColors.accentGreenLight]).createShader(b),
                                    child: Text(AppUtils.formatCurrency(p.price),
                                        style: const TextStyle(color: Colors.white,
                                            fontSize: 26, fontWeight: FontWeight.w800)),
                                  ),
                                  if (p.discount > 0)
                                    Row(children: [
                                      Text(AppUtils.formatCurrency(p.originalPrice),
                                          style: const TextStyle(color: AppColors.textHint,
                                              fontSize: 13, decoration: TextDecoration.lineThrough)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: AppColors.error.withOpacity(0.2),
                                        ),
                                        child: Text('-${p.discount.round()}%',
                                            style: const TextStyle(color: AppColors.error,
                                                fontSize: 11, fontWeight: FontWeight.w700)),
                                      ),
                                    ]),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.bgCard,
                                  border: Border.all(color: AppColors.borderColor),
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 18),
                                    const SizedBox(width: 4),
                                    Text(p.rating.toStringAsFixed(1),
                                        style: const TextStyle(color: AppColors.textPrimary,
                                            fontSize: 16, fontWeight: FontWeight.w700)),
                                  ]),
                                  Text('${AppUtils.formatNumber(p.reviewCount)} ulasan',
                                      style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                                ]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: p.stock > 10 ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                              border: Border.all(
                                  color: p.stock > 10 ? AppColors.success.withOpacity(0.3) : AppColors.warning.withOpacity(0.3)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.inventory_2_rounded,
                                  color: p.stock > 10 ? AppColors.success : AppColors.warning, size: 16),
                              const SizedBox(width: 8),
                              Text(p.stock > 10 ? 'Stok tersedia (${p.stock} unit)' : 'Stok terbatas! Tersisa ${p.stock} unit',
                                  style: TextStyle(color: p.stock > 10 ? AppColors.success : AppColors.warning,
                                      fontSize: 12, fontWeight: FontWeight.w500)),
                            ]),
                          ),
                          const SizedBox(height: 24),
                          _sectionTitle('Deskripsi Produk'),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.bgCard,
                                border: Border.all(color: AppColors.borderColor)),
                            child: Text(p.description,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.7)),
                          ),
                          const SizedBox(height: 24),
                          _sectionTitle('Spesifikasi'),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.bgCard,
                                border: Border.all(color: AppColors.borderColor)),
                            child: Column(
                              children: List.generate(p.specs.length, (i) {
                                final spec = p.specs[i];
                                final parts = spec.split(': ');
                                final key = parts[0];
                                final value = parts.length > 1 ? parts.sublist(1).join(': ') : '';
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: i < p.specs.length - 1
                                        ? const Border(bottom: BorderSide(color: AppColors.borderColor))
                                        : null,
                                  ),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Container(
                                        width: 6, height: 6,
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.accentBlue)),
                                    const SizedBox(width: 10),
                                    Expanded(flex: 2, child: Text(key,
                                        style: const TextStyle(color: AppColors.textSecondary,
                                            fontSize: 13, fontWeight: FontWeight.w500))),
                                    if (value.isNotEmpty)
                                      Expanded(flex: 3, child: Text(value,
                                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                                          textAlign: TextAlign.end)),
                                  ]),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppColors.borderColor)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, -8))],
            ),
            child: Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    provider.addToCart(p);
                    CustomSnackbar.show(context,
                        message: '${p.name} ditambahkan ke keranjang 🛒', isSuccess: true);
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.bgCard,
                      border: Border.all(color: inCart ? AppColors.accentBlue : AppColors.borderColor),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(inCart ? Icons.shopping_cart_rounded : Icons.add_shopping_cart_rounded,
                          color: inCart ? AppColors.accentBlue : AppColors.textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Text(inCart ? 'Tambah Lagi' : 'Keranjang',
                          style: TextStyle(color: inCart ? AppColors.accentBlue : AppColors.textSecondary,
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  text: 'Beli Sekarang',
                  icon: Icons.bolt_rounded,
                  onPressed: () {
                    provider.addToCart(p);
                    CustomSnackbar.show(context,
                        message: 'Berhasil! Cek keranjang belanja Anda 🛍️', isSuccess: true);
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _badge(String text, {bool gradient = false, bool success = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: gradient ? const LinearGradient(colors: [AppColors.accentGreen, AppColors.accentGreenLight]) : null,
        color: success ? AppColors.success.withOpacity(0.2) : (gradient ? null : AppColors.bgCard),
        border: gradient ? null : Border.all(color: success ? AppColors.success.withOpacity(0.5) : AppColors.borderColor),
      ),
      child: Text(text,
          style: TextStyle(
              color: gradient ? Colors.white : (success ? AppColors.success : AppColors.textSecondary),
              fontSize: 11,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700));
  }
}
