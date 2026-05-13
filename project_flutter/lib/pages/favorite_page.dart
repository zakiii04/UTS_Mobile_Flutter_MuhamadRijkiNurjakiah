import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.accentBlue, AppColors.accentPurple],
                    ).createShader(bounds),
                    child: const Text(
                      'Favorit Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.favorite_rounded,
                      color: AppColors.error, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Consumer<ProductProvider>(
              builder: (ctx, provider, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${provider.favoritesCount} produk tersimpan',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (ctx, provider, _) {
                  final favorites = provider.favorites;
                  if (favorites.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.favorite_border_rounded,
                      title: 'Belum Ada Favorit',
                      subtitle:
                          'Tambahkan produk ke favorit dengan menekan ikon hati pada produk',
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (ctx, i) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + (i * 80)),
                        curve: Curves.easeOutCubic,
                        builder: (ctx, val, child) => Opacity(
                          opacity: val,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - val)),
                            child: child,
                          ),
                        ),
                        child: ProductCard(product: favorites[i]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
