import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../data/product_data.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _allProducts = ProductData.products;
  final List<ProductModel> _favorites = [];
  final List<ProductModel> _cart = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<ProductModel> get allProducts => List.unmodifiable(_allProducts);
  List<ProductModel> get favorites => _favorites;
  List<ProductModel> get cart => _cart;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = _allProducts;
    if (_selectedCategory != 'Semua') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  List<ProductModel> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<ProductModel> get newProducts =>
      _allProducts.where((p) => p.isNew).toList();

  int get cartCount => _cart.fold(0, (sum, p) => sum + p.quantity);
  int get favoritesCount => _favorites.length;

  double get cartTotal =>
      _cart.fold(0, (sum, p) => sum + (p.price * p.quantity));

  bool isFavorite(String productId) =>
      _favorites.any((p) => p.id == productId);

  bool isInCart(String productId) => _cart.any((p) => p.id == productId);

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(ProductModel product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void addToCart(ProductModel product) {
    final index = _cart.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(product.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _cart.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _cart.indexWhere((p) => p.id == productId);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

}
