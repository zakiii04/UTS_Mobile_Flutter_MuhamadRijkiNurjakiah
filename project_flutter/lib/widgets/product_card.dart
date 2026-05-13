import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (ctx, provider, _) {
        final isFav = provider.isFavorite(product.id);
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, __) => ProductDetailPage(product: product),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
            ),
          ),
          child: Hero(
            tag: 'product_${product.id}',
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background gradient
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.bgCardLight,
                              ),
                            ),
                            // Real product image
                            if (product.imagePath.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  product.imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    _getIcon(product.iconPath),
                                    size: 64,
                                    color: AppColors.accentBlue.withValues(alpha: 0.7),
                                  ),
                                ),
                              )
                            else
                              Center(
                                child: Icon(
                                  _getIcon(product.iconPath),
                                  size: 64,
                                  color: AppColors.accentBlue.withValues(alpha: 0.7),
                                ),
                              ),
                            // Badges
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.isNew)
                                    _badge('NEW', AppColors.success),
                                  if (product.discount > 0) ...[
                                    if (product.isNew) const SizedBox(height: 4),
                                    _badge('-${product.discount.round()}%', AppColors.error),
                                  ],
                                ],
                              ),
                            ),
                            // Favorite Button
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => provider.toggleFavorite(product),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.9),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFav ? AppColors.error : AppColors.textMuted,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Info Section
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.brand,
                                  style: const TextStyle(
                                    color: AppColors.accentBlue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.accentGold, size: 12),
                                    const SizedBox(width: 3),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${AppUtils.formatNumber(product.reviewCount)})',
                                      style: const TextStyle(
                                        color: AppColors.textHint,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppUtils.formatCurrency(product.price),
                                  style: const TextStyle(
                                    color: AppColors.accentGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (product.discount > 0)
                                  Text(
                                    AppUtils.formatCurrency(product.originalPrice),
                                    style: const TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  IconData _getIcon(String iconPath) {
    switch (iconPath) {
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
