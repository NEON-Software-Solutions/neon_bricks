import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeSignUpParams extends Fake implements SignUpParams {}

SignUpUC _setUpUCWithMockRepo(Either<Failure, User> returnValue) {
  final mockRepo = MockAuthenticationRepository();
  when(() => mockRepo.signUp(any<SignUpParams>()))
      .thenAnswer((_) async => returnValue);

  return SignUpUC(mockRepo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSignUpParams());
  });

  const params = SignUpParams(
    email: 'email',
    password: 'password',
    username: 'username',
  );

  test('AuthRepo.signUp is called', () {
    final useCase = _setUpUCWithMockRepo(const Left(Failure()));

    useCase.call(params).then((_) =>
        verify(() => useCase.authenticationRepository.signUp(any())).called(1));
  });

  test('Returns Left<Failure> if AuthRepo.signUp returns Left<Failure>', () {
    const Left<Failure, User> expectedReturnValue = Left(Failure());
    final useCase = _setUpUCWithMockRepo(expectedReturnValue);

    useCase.call(params).then((value) => expect(value, expectedReturnValue));
  });

  test('Returns Right<User> if AuthRepo.signUp returns Right<User>', () {
    final Right<Failure, User> expectedReturnValue =
        Right(User(name: 'name', id: 'id'));
    final useCase = _setUpUCWithMockRepo(expectedReturnValue);

    useCase.call(params).then((value) => expect(value, expectedReturnValue));
  });
}
