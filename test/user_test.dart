import 'package:flutter_test/flutter_test.dart';
import 'package:csms_app/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('supports value comparisons', () {
      const user1 = User(
        id: '1',
        email: 'test@test.com',
        name: 'Test',
        role: UserRole.admin,
      );
      const user2 = User(
        id: '1',
        email: 'test@test.com',
        name: 'Test',
        role: UserRole.admin,
      );
      expect(user1, user2);
    });
  });
}
