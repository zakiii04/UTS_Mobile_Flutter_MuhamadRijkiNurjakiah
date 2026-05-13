import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';
import '../data/product_data.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import '../utils/app_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _searchController = TextEditingController();
  int _currentBanner = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Fashion Terbaik',
      'subtitle': 'Nike • Uniqlo • Zara',
      'tag': 'Diskon 30%',
      'color1': const Color(0xFF03AC0E),
      'color2': const Color(0xFF42B549),
      'image': 'assets/images/nike_shoes.png',
    },
    {
      'title': 'Produk Kecantikan',
      'subtitle': 'Skincare Pilihan Terbaik',
      'tag': 'Diskon 25%',
      'color1': const Color(0xFF00B1A9),
      'color2': const Color(0xFF03AC0E),
      'image': 'assets/images/avoskin_serum.png',
    },
    {
      'title': 'Elektronik & Gadget',
      'subtitle': 'iPhone 16 • Tersedia Sekarang',
      'tag': 'Terlaris!',
      'color1': const Color(0xFF03AC0E),
      'color2': const Color(0xFF8BC34A),
      'image': 'assets/images/iphone16.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerRotation();
  }

  void _startBannerRotation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) setState(() => _currentBanner = (_currentBanner + 1) % _banners.length);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(
        searchController: _searchController,
        banners: _banners,
        currentBanner: _currentBanner,
        onBannerChange: (i) => setState(() => _currentBanner = i),
      ),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: IndexedStack(
        index: _currentIndex.clamp(0, pages.length - 1),
        children: pages,
      ),
      floatingActionButton: _currentIndex == 0
          ? _buildFAB()
          : null,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.accentGreen, AppColors.accentGreenLight],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => CustomSnackbar.show(
          context,
          message: '⚡ Flash Sale aktif! Diskon hingga 50% untuk produk pilihan',
          isSuccess: true,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Consumer<ProductProvider>(
      builder: (ctx, provider, _) {
        final items = [
          _NavData(Icons.home_rounded, 'Beranda', 0),
          _NavData(Icons.shopping_cart_rounded, 'Keranjang', 1, badge: provider.cartCount),
          _NavData(Icons.person_rounded, 'Profil', 2),
        ];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: AppColors.borderColor, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) => _NavItem(
                  data: item,
                  isActive: _currentIndex == item.index,
                  onTap: () => setState(() => _currentIndex = item.index),
                )).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavData {
  final IconData icon;
  final String label;
  final int index;
  final int badge;
  const _NavData(this.icon, this.label, this.index, {this.badge = 0});
}

class _NavItem extends StatelessWidget {
  final _NavData data;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.data, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? AppColors.accentGreen.withOpacity(0.08) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BadgeWidget(
              count: data.badge,
              child: Icon(
                data.icon,
                color: isActive ? AppColors.accentGreen : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                color: isActive ? AppColors.accentGreen : AppColors.textMuted,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home Content ─────────────────────────────────────────────────────────────

class _HomeContent extends StatefulWidget {
  final TextEditingController searchController;
  final List<Map<String, dynamic>> banners;
  final int currentBanner;
  final Function(int) onBannerChange;

  const _HomeContent({
    required this.searchController,
    required this.banners,
    required this.currentBanner,
    required this.onBannerChange,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final user = auth.currentUser;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          CustomSnackbar.show(context, message: 'Produk diperbarui ✓', isSuccess: true);
        }
      },
      color: AppColors.accentGreen,
      backgroundColor: AppColors.bgCard,
      child: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 120,
            collapsedHeight: 60,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildAppBarContent(user, auth),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Search Bar ─────────────────────────────────────────
                  _buildSearchBar(productProvider),
                  const SizedBox(height: 20),

                  // ── Banner ─────────────────────────────────────────────
                  _buildBannerSection(),
                  const SizedBox(height: 20),

                  // ── Quick Stats ────────────────────────────────────────
                  _buildQuickStats(productProvider),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Categories ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 16),
              child: _buildSectionTitle('Kategori'),
            ),
          ),
          _buildCategories(productProvider),

          // ── Products Header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(productProvider.selectedCategory == 'Semua'
                      ? 'Semua Produk'
                      : productProvider.selectedCategory),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Text(
                      '${productProvider.filteredProducts.length} produk',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Flash Sale (ListView Requirement) ──────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('⚡ Flash Sale'),
                      const Text(
                        'Berakhir dalam 02:14:35',
                        style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.allProducts.length,
                      itemBuilder: (ctx, i) {
                        final product = productProvider.allProducts[i];
                        if (!product.isFeatured) return const SizedBox.shrink();
                        
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.bgCard,
                            border: Border.all(color: AppColors.borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: AppColors.bgSecondary,
                                  child: Icon(
                                    _getIcon(product.iconPath),
                                    size: 50,
                                    color: AppColors.accentGreen.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: AppColors.textPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppUtils.formatCurrency(product.price),
                                      style: const TextStyle(
                                          color: AppColors.accentGreen,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    // Progress bar
                                    Container(
                                      height: 6,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: AppColors.bgTertiary,
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.error,
                                                AppColors.accentGold
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Segera Habis',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: AppColors.textMuted,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Product Grid ──────────────────────────────────────────────────

          _buildProductGrid(productProvider),
        ],
      ),
    );
  }

  Widget _buildAppBarContent(user, auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('👋 ', style: TextStyle(fontSize: 16)),
                  Text(
                    'Halo, ${user?.name.split(' ').first ?? 'Pengguna'}!',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                'Tokopadia',
                style: GoogleFonts.outfit(
                  color: AppColors.accentGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.accentGreen, AppColors.accentGreenLight],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGreen.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ProductProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.bgCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: widget.searchController,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari produk, merek, kategori...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.accentGreen, AppColors.accentGreenLight],
            ).createShader(b),
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
          ),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textHint, size: 18),
                  onPressed: () {
                    widget.searchController.clear();
                    provider.setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (val) {
          provider.setSearchQuery(val);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: _BannerCard(
            key: ValueKey(widget.currentBanner),
            banner: widget.banners[widget.currentBanner],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == widget.currentBanner ? 28 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: i == widget.currentBanner
                    ? const LinearGradient(
                        colors: [AppColors.accentGreen, AppColors.accentGreenLight])
                    : null,
                color: i == widget.currentBanner ? null : AppColors.textHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(ProductProvider provider) {
    final stats = [
      {'label': 'Produk', 'value': '${provider.allProducts.length}+', 'icon': Icons.inventory_2_rounded},
      {'label': 'Merek', 'value': '12+', 'icon': Icons.business_rounded},
      {'label': 'Rating', 'value': '4.8', 'icon': Icons.star_rounded},
      {'label': 'Pengiriman', 'value': 'Gratis', 'icon': Icons.local_shipping_rounded},
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                Icon(s['icon'] as IconData,
                    color: AppColors.accentGreen, size: 20),
                const SizedBox(height: 4),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  s['label'] as String,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCategories(ProductProvider provider) {
    final categories = ProductData.categories;
    final icons = {
      'Semua': Icons.apps_rounded,
      'Elektronik': Icons.devices_rounded,
      'Fashion': Icons.checkroom_rounded,
      'Makanan': Icons.restaurant_rounded,
      'Kecantikan': Icons.face_retouching_natural_rounded,
      'Rumah Tangga': Icons.home_rounded,
    };

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 76,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          itemBuilder: (ctx, i) {
            final cat = categories[i];
            final isSelected = provider.selectedCategory == cat;
            return GestureDetector(
              onTap: () => provider.setCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [AppColors.accentGreen, AppColors.accentGreenLight])
                            : null,
                        color: isSelected ? null : AppColors.bgCard,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.borderColor,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.accentGreen.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        icons[cat] ?? Icons.devices_rounded,
                        color: isSelected ? Colors.white : AppColors.textHint,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.accentGreen
                            : AppColors.textHint,
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider provider) {
    final products = provider.filteredProducts;

    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'Produk Tidak Ditemukan',
          subtitle: 'Coba kata kunci lain atau ubah filter kategori',
          buttonText: 'Reset Filter',
          onButtonPressed: () {
            provider.setCategory('Semua');
            provider.setSearchQuery('');
            widget.searchController.clear();
          },
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 350 + (i * 60)),
            curve: Curves.easeOutCubic,
            builder: (ctx, val, child) => Opacity(
              opacity: val.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 24 * (1 - val)),
                child: child,
              ),
            ),
            child: ProductCard(product: products[i]),
          ),
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
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
      case 'fashion': return Icons.checkroom_rounded;
      case 'food': return Icons.restaurant_rounded;
      case 'beauty': return Icons.face_retouching_natural_rounded;
      case 'furniture': return Icons.home_rounded;
      default: return Icons.devices_rounded;
    }
  }
}

// ─── Banner Card ──────────────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final Map<String, dynamic> banner;
  const _BannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [banner['color1'] as Color, banner['color2'] as Color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            // Content
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accentGreen.withValues(alpha: 0.5),
                                AppColors.accentGreenLight.withValues(alpha: 0.5),
                              ],
                            ),
                            border: Border.all(
                                color: AppColors.accentGreen.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            banner['tag'] as String,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          banner['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.accentBlue,
                                AppColors.accentPurple
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentBlue.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Beli Sekarang →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      banner['image'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.devices_rounded,
                        color: Colors.white24,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
