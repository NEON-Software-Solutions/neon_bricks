import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeLoginParams extends Fake implements LoginParams {}

LoginUC _setUpUCWithMockRepo(Either<Failure, User> returnValue) {
  final mockRepo = MockAuthenticationRepository();
  when(() => mockRepo.login(any<LoginParams>()))
      .thenAnswer((_) async => returnValue);

  return LoginUC(mockRepo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  const params = LoginParams(email: 'email', password: 'password');

  test('AuthRepo.login is called', () {
    final useCase = _setUpUCWithMockRepo(const Left(Failure()));

    useCase.call(params).then((_) =>
        verify(() => useCase.authenticationRepository.login(any())).called(1));
  });

  test('Returns Left<Failure> if AuthRepo.login returns Left<Failure>', () {
    const Left<Failure, User> expectedReturnValue = Left(Failure());
    final useCase = _setUpUCWithMockRepo(expectedReturnValue);

    useCase.call(params).then((value) => expect(value, expectedReturnValue));
  });

  test('Returns Right<User> if AuthRepo.login returns Right<User>', () {
    final Right<Failure, User> expectedReturnValue =
        Right(User(name: 'name', id: 'id'));
    final useCase = _setUpUCWithMockRepo(expectedReturnValue);

    useCase.call(params).then((value) => expect(value, expectedReturnValue));
  });
}
