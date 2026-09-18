class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  String role;
  DateTime? createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.role = 'user',
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim().isEmpty ? username : '$firstName $lastName';

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role,
      'CreatedAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id']?.toString() ?? '',
      firstName: data['FirstName'] ?? data['firstName'] ?? '',
      lastName: data['LastName'] ?? data['lastName'] ?? '',
      username: data['Username'] ?? data['username'] ?? '',
      email: data['Email'] ?? data['email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? data['phoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? data['profilePicture'] ?? '',
      role: data['Role'] ?? data['role'] ?? 'user',
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'].toString()) : null,
    );
  }
}
