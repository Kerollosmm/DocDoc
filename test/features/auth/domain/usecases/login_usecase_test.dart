import 'package:csms/core/error/failures.dart';
import 'package:csms/features/auth/domain/entities/user_entity.dart';
import 'package:csms/features/auth/domain/repositories/auth_repository.dart';
import 'package:csms/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password';
  final tUser = UserEntity(id: '1', email: tEmail, role: 'servant');

  test('should call login on repository and return UserEntity', () async {
    // Arrange
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => Right(tUser));

    // Act
    final result = await loginUseCase(tEmail, tPassword);

    // Assert
    expect(result, Right(tUser));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when repository fails', () async {
    // Arrange
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => const Left(ServerFailure('Login failed')));

    // Act
    final result = await loginUseCase(tEmail, tPassword);

    // Assert
    expect(result, const Left(ServerFailure('Login failed')));
  });
}
