import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/data/models/user_model.dart';

void main() {
  group('UserModel Unit Tests', () {
    test('UserModel.fromJson correctly parses data with Role and names', () {
      final json = {
        'id': 'admin_123',
        'FirstName': 'Admin',
        'LastName': 'User',
        'Username': 'admin_s_store',
        'Email': 'admin@sstore.com',
        'PhoneNumber': '+123456789',
        'ProfilePicture': 'https://example.com/avatar.png',
        'Role': 'admin',
        'created_at': '2026-09-15T12:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'admin_123');
      expect(user.firstName, 'Admin');
      expect(user.lastName, 'User');
      expect(user.fullName, 'Admin User');
      expect(user.username, 'admin_s_store');
      expect(user.email, 'admin@sstore.com');
      expect(user.role, 'admin');
      expect(user.createdAt, isNotNull);
    });

    test('UserModel.empty creates an empty user with role user', () {
      final emptyUser = UserModel.empty();
      expect(emptyUser.id, isEmpty);
      expect(emptyUser.email, isEmpty);
      expect(emptyUser.role, 'user');
    });

    test('UserModel.toJson correctly maps fields to JSON', () {
      final user = UserModel(
        id: 'admin_1',
        firstName: 'Super',
        lastName: 'Admin',
        username: 'superadmin',
        email: 'super@store.com',
        phoneNumber: '0123456789',
        profilePicture: 'avatar.jpg',
        role: 'admin',
      );

      final json = user.toJson();
      expect(json['id'], 'admin_1');
      expect(json['FirstName'], 'Super');
      expect(json['LastName'], 'Admin');
      expect(json['Role'], 'admin');
      expect(json['Email'], 'super@store.com');
    });
  });
}
