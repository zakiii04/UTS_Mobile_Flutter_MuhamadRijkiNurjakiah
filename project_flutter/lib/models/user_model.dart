class UserModel {
  final String id;
  String name;
  String email;
  String phone;
  String address;
  String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
    required this.password,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      password: password ?? this.password,
    );
  }
}
