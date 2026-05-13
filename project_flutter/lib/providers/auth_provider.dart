import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isDarkMode = false;

  // Simulated registered users list
  final List<UserModel> _registeredUsers = [
    UserModel(
      id: 'user_001',
      name: 'Zaki',
      email: 'zaki@gmail.com',
      phone: '08567890123',
      address: 'Jl. Merdeka No. 45, Bandung',
      password: 'user123',
    ),
    UserModel(
      id: 'user_002',
      name: 'Siti Rahayu',
      email: 'siti@gmail.com',
      phone: '08987654321',
      address: 'Jl. Sudirman No. 10, Surabaya',
      password: 'user123',
    ),
  ];

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  bool get isLoggedIn => _currentUser != null;
  List<UserModel> get allUsers => List.unmodifiable(_registeredUsers);

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final user = _registeredUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      orElse: () => UserModel(id: '', name: '', email: '', password: ''),
    );

    _isLoading = false;

    if (user.id.isNotEmpty) {
      _currentUser = user;
      notifyListeners();
      return null;
    } else {
      notifyListeners();
      return 'Email atau password salah';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    final exists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (exists) {
      _isLoading = false;
      notifyListeners();
      return 'Email sudah terdaftar';
    }

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
    );

    _registeredUsers.add(newUser);
    _isLoading = false;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        address: address ?? _currentUser!.address,
      );
      notifyListeners();
    }
  }

}
