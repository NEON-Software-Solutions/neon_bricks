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
import 'package:candy_core/candy_core.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';{{#firebase_crashlytics_feature}}
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:{{project_name}}/injection.dart';{{/firebase_crashlytics_feature}}
import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart'
    as my_user;
{{#firebase_crashlytics_feature}}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}{{/firebase_crashlytics_feature}}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCreds extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

AuthenticationDatasource _setupDataSourceSignInWithException(
    Exception throwable) {
  final mockAuth = MockFirebaseAuth();
  when(
    () => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenThrow(throwable);

  return AuthenticationDatasource(mockAuth);
}

AuthenticationDatasource _setupDataSourceSignUpWithException(
    Exception throwable) {
  final mockAuth = MockFirebaseAuth();
  when(
    () => mockAuth.createUserWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenThrow(throwable);

  return AuthenticationDatasource(mockAuth);
}

AuthenticationDatasource _setupDataSourceSignInWithMockCredentials({
  required UserCredential credentials,
  User? authMockCurrentUser,
}) {
  final mockAuth = MockFirebaseAuth();
  when(
    () => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => credentials);
  when(() => mockAuth.currentUser).thenReturn(authMockCurrentUser);

  return AuthenticationDatasource(mockAuth);
}

AuthenticationDatasource _setupDataSourceSignUpWithMockCredentials({
  required UserCredential credentials,
}) {
  final mockAuth = MockFirebaseAuth();
  when(
    () => mockAuth.createUserWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => credentials);

  return AuthenticationDatasource(mockAuth);
}

void main() { {{#firebase_crashlytics_feature}}
  setUpAll(() {
    registerFallbackValue(Exception());
    final mockCrashlytics = MockFirebaseCrashlytics();
    when(() =>
            mockCrashlytics.recordError(any<Exception>(), any<StackTrace?>()))
        .thenAnswer(
      (_) async {},
    );

    getIt.registerSingleton<FirebaseCrashlytics>(mockCrashlytics);
  });{{/firebase_crashlytics_feature}}

  group('Login', () {
    const loginParams = LoginParams(email: 'email', password: 'password');
    test('Returns Left<Failure> when FirebaseAuth.signIn throws', () {
      final dataSource = _setupDataSourceSignInWithException(Exception());
      dataSource
          .login(loginParams)
          .then((value) => expect(value, const Left(Failure())));
    });

    test('FirebaseAuth.signIn is called exactly once', () {
      final mockAuth = MockFirebaseAuth();
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception());

      final dataSource = AuthenticationDatasource(mockAuth);
      dataSource
          .login(loginParams)
          .then((_) => verify(() => mockAuth.signInWithEmailAndPassword(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).called(1));
    });

    test('Returns Left<Failure> if returned UserCreds.user == null', () {
      final mockCreds = MockUserCreds();

      final dataSource =
          _setupDataSourceSignInWithMockCredentials(credentials: mockCreds);
      dataSource.login(loginParams).then((returnValue) => expect(
          returnValue,
          const Left(Failure(
              'Received UserCreds with null user from FirebaseAuth after login'))));
    });

    test(
        'Returns default username if userCreds.user.displayName == null and currentUser == null',
        () {
      const mockUID = 'my-mock-uid';
      final mockUser = MockUser();
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.uid).thenReturn(mockUID);
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final dataSource =
          _setupDataSourceSignInWithMockCredentials(credentials: mockCreds);

      dataSource.login(loginParams).then(
            (returnValue) => expect(
              returnValue,
              Right(
                my_user.User(
                  name: 'noUserName'.tr(),
                  id: mockUID,
                ),
              ),
            ),
          );
    });

    test(
        'Returns default username if userCreds.user.displayName == null and currentUser.displayName == null',
        () {
      const mockUID = 'my-mock-uid';
      final mockUser = MockUser();
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.uid).thenReturn(mockUID);
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final dataSource = _setupDataSourceSignInWithMockCredentials(
        credentials: mockCreds,
        authMockCurrentUser: mockUser,
      );
      dataSource.login(loginParams).then(
            (returnValue) => expect(
              returnValue,
              Right(
                my_user.User(
                  name: 'noUserName'.tr(),
                  id: mockUID,
                ),
              ),
            ),
          );
    });

    test(
        'Returns currentUser.displayName if non-null and userCreds.user == null',
        () {
      const mockUID = 'my-mock-uid';
      final mockUser = MockUser();
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.uid).thenReturn(mockUID);
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final mockUserWithName = MockUser();
      when(() => mockUserWithName.displayName).thenReturn('cool name');

      final dataSource = _setupDataSourceSignInWithMockCredentials(
        credentials: mockCreds,
        authMockCurrentUser: mockUserWithName,
      );
      dataSource.login(loginParams).then(
            (returnValue) => expect(
              returnValue,
              Right(
                my_user.User(
                  name: 'cool name',
                  id: mockUID,
                ),
              ),
            ),
          );
    });

    test('Returns userCreds.user.displayName if non-null', () {
      const mockUID = 'my-mock-uid';
      final mockUser = MockUser();
      when(() => mockUser.displayName).thenReturn('cool name too');
      when(() => mockUser.uid).thenReturn(mockUID);
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final dataSource = _setupDataSourceSignInWithMockCredentials(
        credentials: mockCreds,
      );
      dataSource.login(loginParams).then(
            (returnValue) => expect(
              returnValue,
              Right(
                my_user.User(
                  name: 'cool name too',
                  id: mockUID,
                ),
              ),
            ),
          );
    });

    group('Error messages', () {
      test(
          'Invalid Email error message emitted on FirebaseAuthException/invalid-email',
          () {
        final dataSource = _setupDataSourceSignInWithException(
            FirebaseAuthException(code: 'invalid-email'));
        dataSource
            .login(loginParams)
            .then((value) => expect(value, Left(Failure('invalidEmail'.tr()))));
      });

      test(
          'User Disabled error message emitted on FirebaseAuthException/user-disabled',
          () {
        final dataSource = _setupDataSourceSignInWithException(
            FirebaseAuthException(code: 'user-disabled'));
        dataSource
            .login(loginParams)
            .then((value) => expect(value, Left(Failure('userDisabled'.tr()))));
      });

      test(
          'User Not Found error message emitted on FirebaseAuthException/user-not-found',
          () {
        final dataSource = _setupDataSourceSignInWithException(
            FirebaseAuthException(code: 'user-not-found'));
        dataSource
            .login(loginParams)
            .then((value) => expect(value, Left(Failure('userNotFound'.tr()))));
      });

      test(
          'Wrong Password error message emitted on FirebaseAuthException/wrong-password',
          () {
        final dataSource = _setupDataSourceSignInWithException(
            FirebaseAuthException(code: 'wrong-password'));
        dataSource.login(loginParams).then(
            (value) => expect(value, Left(Failure('wrongPassword'.tr()))));
      });
    });
  });
  group('SignUp', () {
    const signUpParams = SignUpParams(
        email: 'email', password: 'password', username: 'username');

    test('FirebaseAuth.createUserWithEmailAndPassword is called exactly once',
        () {
      final mockAuth = MockFirebaseAuth();
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception());

      final dataSource = AuthenticationDatasource(mockAuth);
      dataSource
          .signUp(signUpParams)
          .then((_) => verify(() => mockAuth.createUserWithEmailAndPassword(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).called(1));
    });

    test(
        'Returns Left<Failure> when FirebaseAuth.createUserWithEmailAndPassword throws',
        () {
      final dataSource = _setupDataSourceSignUpWithException(Exception());
      dataSource
          .signUp(signUpParams)
          .then((returnValue) => expect(returnValue, const Left(Failure())));
    });

    test('user.updateDisplayName is called when user != null', () {
      final mockUser = MockUser();
      when(() => mockUser.updateDisplayName(any<String>()))
          .thenAnswer((_) async {});
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final dataSource =
          _setupDataSourceSignUpWithMockCredentials(credentials: mockCreds);
      dataSource.signUp(signUpParams).then((_) =>
          verify(() => mockUser.updateDisplayName(any<String>())).called(1));
    });

    test('Returns Left<Failure> if create returns user creds with null user',
        () {
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(null);
      final dataSource =
          _setupDataSourceSignUpWithMockCredentials(credentials: mockCreds);
      dataSource.signUp(signUpParams).then((returnValue) => expect(
          returnValue,
          const Left(Failure(
              'Received UserCreds with null user from FirebaseAuth after sign up'))));
    });

    test('Returns Right<User> if everything passes', () {
      const mockUID = 'my-mock-uid';
      final mockUser = MockUser();
      when(() => mockUser.uid).thenReturn(mockUID);
      when(() => mockUser.updateDisplayName(any<String>()))
          .thenAnswer((_) async {});
      final mockCreds = MockUserCreds();
      when(() => mockCreds.user).thenReturn(mockUser);

      final dataSource =
          _setupDataSourceSignUpWithMockCredentials(credentials: mockCreds);
      dataSource.signUp(signUpParams).then((value) => expect(value,
          Right(my_user.User(name: signUpParams.username, id: mockUID))));
    });

    group('Error Messages', () {
      test(
          'Invalid Email error message emitted on FirebaseAuthException/invalid-email',
          () {
        final dataSource = _setupDataSourceSignUpWithException(
            FirebaseAuthException(code: 'invalid-email'));
        dataSource
            .signUp(signUpParams)
            .then((value) => expect(value, Left(Failure('invalidEmail'.tr()))));
      });

      test(
          'Email Already in Use error message emitted on FirebaseAuthException/email-already-in-use',
          () {
        final dataSource = _setupDataSourceSignUpWithException(
            FirebaseAuthException(code: 'email-already-in-use'));
        dataSource.signUp(signUpParams).then(
            (value) => expect(value, Left(Failure('emailAlreadyInUse'.tr()))));
      });

      test(
          'Operation Not Allowed error message emitted on FirebaseAuthException/operation-not-allowed',
          () {
        final dataSource = _setupDataSourceSignUpWithException(
            FirebaseAuthException(code: 'operation-not-allowed'));
        dataSource.signUp(signUpParams).then((value) =>
            expect(value, Left(Failure('operationNotAllowed'.tr()))));
      });

      test(
          'Weak Password error message emitted on FirebaseAuthException/weak-password',
          () {
        final dataSource = _setupDataSourceSignUpWithException(
            FirebaseAuthException(code: 'weak-password'));
        dataSource
            .signUp(signUpParams)
            .then((value) => expect(value, Left(Failure('weakPassword'.tr()))));
      });
    });
  });
}
{{/authentication_firebase_auth_feature}}