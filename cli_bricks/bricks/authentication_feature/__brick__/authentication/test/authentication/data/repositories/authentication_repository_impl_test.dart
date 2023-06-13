import 'package:flutter_test/flutter_test.dart';

{{^authentication_firebase_auth_feature}}
void main(){
  //TODO: implement this one!
  test('do something', (){
    expect(true,false);
  });
}
{{/authentication_firebase_auth_feature}}
{{#authentication_firebase_auth_feature}}
import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';{{#firebase_crashlytics_feature}}
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:{{project_name}}/injection.dart';{{/firebase_crashlytics_feature}}
import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

{{#firebase_crashlytics_feature}}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}{{/firebase_crashlytics_feature}}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDatasource {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeSignUpParams extends Fake implements SignUpParams {}

AuthenticationRepository _setupRepoWithMockDataSource(
    Either<Failure, User> dataSourceReturnValue) {
  final mockDataSource = MockAuthenticationDataSource();
  when(() => mockDataSource.login(any<LoginParams>()))
      .thenAnswer((_) async => dataSourceReturnValue);
  when(() => mockDataSource.signUp(any<SignUpParams>()))
      .thenAnswer((_) async => dataSourceReturnValue);

  return AuthenticationRepositoryImpl(mockDataSource);
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeSignUpParams());{{#firebase_crashlytics_feature}}
    registerFallbackValue(Exception());

    final mockCrashlytics = MockFirebaseCrashlytics();
    when(() =>
            mockCrashlytics.recordError(any<Exception>(), any<StackTrace?>()))
        .thenAnswer(
      (_) async {},
    );

    getIt.registerSingleton<FirebaseCrashlytics>(mockCrashlytics);{{/firebase_crashlytics_feature}}
  });
  group('Login', () {
    test('Returns Left<Failure> when Datasource.login returns Left<Failure>',
        () {
      const Left<Failure, User> expectedReturnValue = Left(Failure());
      final repo = _setupRepoWithMockDataSource(expectedReturnValue);
      repo
          .login(const LoginParams(email: 'email', password: 'password'))
          .then((value) => expect(value, expectedReturnValue));
    });

    test('Returns Left<Failure> when Datasource.login throws', () {
      final mockDataSource = MockAuthenticationDataSource();
      when(() => mockDataSource.login(any<LoginParams>()))
          .thenThrow(Exception());

      final repo = AuthenticationRepositoryImpl(mockDataSource);
      repo
          .login(const LoginParams(email: 'email', password: 'password'))
          .then((value) => expect(value, const Left(Failure())));
    });
    test('Returns Right<User> when Datasource.login returns Right<User>', () {
      final Right<Failure, User> expectedReturnValue =
          Right(User(name: 'name', id: 'id'));
      final repo = _setupRepoWithMockDataSource(expectedReturnValue);
      repo
          .login(const LoginParams(email: 'email', password: 'password'))
          .then((value) => expect(value, expectedReturnValue));
    });
  });
  group('SignUp', () {
    test('Returns Left<Failure> when Datasource.signUp returns Left<Failure>',
        () {
      const Left<Failure, User> expectedReturnValue = Left(Failure());
      final repo = _setupRepoWithMockDataSource(expectedReturnValue);
      repo
          .signUp(const SignUpParams(
              username: 'username', email: 'email', password: 'password'))
          .then((value) => expect(value, expectedReturnValue));
    });

    test('Returns Left<Failure> when Datasource.signUp throws', () {
      final mockDataSource = MockAuthenticationDataSource();
      when(() => mockDataSource.signUp(any<SignUpParams>()))
          .thenThrow(Exception());

      final repo = AuthenticationRepositoryImpl(mockDataSource);
      repo
          .signUp(const SignUpParams(
              username: 'username', email: 'email', password: 'password'))
          .then((value) => expect(value, const Left(Failure())));
    });
    test('Returns Right<User> when Datasource.signUp returns Right<User>', () {
      final Right<Failure, User> expectedReturnValue =
          Right(User(name: 'name', id: 'id'));
      final repo = _setupRepoWithMockDataSource(expectedReturnValue);
      repo
          .signUp(const SignUpParams(
              username: 'username', email: 'email', password: 'password'))
          .then((value) => expect(value, expectedReturnValue));
    });
  });
}
{{/authentication_firebase_auth_feature}}