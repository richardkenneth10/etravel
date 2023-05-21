class UserData {
  UserData({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.email = '',
    this.image,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? image;

  factory UserData.fromJson(Map<String, dynamic> m) {
    return UserData(
      id: m['userId'] as int,
      firstName: m['first_name'] as String? ?? '',
      lastName: m['last_name'] as String? ?? '',
      phone: m['phone'] as String? ?? '',
      email: m['email'] as String? ?? '',
      image: m['image_url'] as String?,
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'userId': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'image': image,
    };
  }

  UserData copyWithJson(Map<String, dynamic> m) {
    return UserData(
      id: m['userId'] as int,
      firstName: m['first_name'] as String? ?? firstName,
      lastName: m['last_name'] as String? ?? lastName,
      phone: m['phone'] as String? ?? phone,
      email: m['email'] as String? ?? email,
      image: m['image'] as String? ?? image,
    );
  }

  String get displayName => firstName.isNotEmpty || lastName.isNotEmpty
      ? "$firstName $lastName"
      : 'Anonymous';
}
