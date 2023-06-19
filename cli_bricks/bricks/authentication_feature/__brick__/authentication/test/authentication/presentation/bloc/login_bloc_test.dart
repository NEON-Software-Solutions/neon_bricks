import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/authentication/domain/params/params.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class EventFunctions {
  onError(String string) {}
  onSuccess(User user) {}
}

class MockFunctions extends Mock implements EventFunctions {}

class MockAuthenticationRepo extends Mock implements AuthenticationRepository {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeUser extends Fake implements User {}

LoginBloc _buildLoginBlocWithMockAuthRepo(
    {Either<Failure, User>? mockReturnValue}) {
  final mockAuthRepo = MockAuthenticationRepo();
  if (mockReturnValue != null) {
    when(
      () => mockAuthRepo.login(any<FakeLoginParams>()),
    ).thenAnswer((_) async => mockReturnValue);
  }

  return LoginBloc(mockAuthRepo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeUser());
  });
  blocTest<LoginBloc, LoginState>(
    "LoginBloc's initial state is an empty editing State",
    build: () {
      final mockAuthRepo = MockAuthenticationRepo();
      return LoginBloc(mockAuthRepo);
    },
    verify: (bloc) {
      expect(bloc.state.loading, false);
      expect(bloc.state.email, isNull);
      expect(bloc.state.password, isNull);
    },
  );
  blocTest<LoginBloc, LoginState>(
    "LoginBloc emits nothing when nothing is added",
    build: () {
      final mockAuthRepo = MockAuthenticationRepo();
      return LoginBloc(mockAuthRepo);
    },
    expect: () => const [],
  );

  group('onChangeEmail', () {
    blocTest<LoginBloc, LoginState>(
      "onChangeEmail emits nothing if state.loading",
      seed: () => const LoginState.editing(loading: true),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const LoginEvent.changeEmail(email: 'email'))),
      expect: () => [],
    );

    blocTest<LoginBloc, LoginState>(
      "onChangeEmail updates email",
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const LoginEvent.changeEmail(email: 'email'))),
      expect: () => [
        const LoginState.editing(
          password: null,
          loading: false,
          email: 'email',
        )
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "onChangeEmail only updates email",
      seed: () => const LoginState.editing(password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const LoginEvent.changeEmail(email: 'email'))),
      expect: () => [
        const LoginState.editing(
          password: 'password',
          loading: false,
          email: 'email',
        )
      ],
    );
  });

  group('onChangePassword', () {
    blocTest<LoginBloc, LoginState>(
      "onChangePassword emits nothing if state.loading",
      seed: () => const LoginState.editing(loading: true),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const LoginEvent.changePassword(password: 'password'))),
      expect: () => [],
    );

    blocTest<LoginBloc, LoginState>(
      "onChangePassword updates password",
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const LoginEvent.changePassword(password: 'password'))),
      expect: () => [
        const LoginState.editing(
          password: 'password',
          loading: false,
          email: null,
        )
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "onChangePassword only updates password",
      seed: () => const LoginState.editing(email: 'email'),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const LoginEvent.changePassword(password: 'password'))),
      expect: () => [
        const LoginState.editing(
          password: 'password',
          loading: false,
          email: 'email',
        )
      ],
    );
  });

  group('onLogin', () {
    final functionsMock = MockFunctions();
    blocTest<LoginBloc, LoginState>(
      "onLogin emits nothing when LoginBloc.canLogin is false",
      build: () {
        final bloc = MockLoginBloc();
        when(() => bloc.canLogin).thenReturn(false);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginEvent.startLocalLogin()),
      expect: () => const [],
      verify: (bloc) => expect(bloc.canLogin, false),
    );

    blocTest<LoginBloc, LoginState>(
      "onLogin emits original state when login fails",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure())),
      act: (bloc) => bloc.add(const LoginEvent.startLocalLogin()),
      expect: () => const [
        LoginState.editing(
          email: 'email',
          password: 'password',
          loading: true,
        ),
        LoginState.editing(
          email: 'email',
          password: 'password',
          loading: false,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "onLogin emits previous state with loading = true when login succeeds",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) => bloc.add(const LoginEvent.startLocalLogin()),
      expect: () => const [
        LoginState.editing(
          email: 'email',
          password: 'password',
          loading: true,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "only onError is called once when login fails",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure())),
      act: (bloc) {
        final event = LoginEvent.startLocalLogin(
          onError: functionsMock.onError,
          onSuccess: functionsMock.onSuccess,
        );
        bloc.add(event);
      },
      verify: (_) {
        verify(
          () => functionsMock.onError(any<String>()),
        ).called(1);
        verifyNever(
          () => functionsMock.onSuccess(any<FakeUser>()),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      "onError is called with given failure error message when login fails",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure('my-error-message'))),
      act: (bloc) {
        final event = LoginEvent.startLocalLogin(
          onError: functionsMock.onError,
          onSuccess: functionsMock.onSuccess,
        );
        bloc.add(event);
      },
      verify: (_) {
        verify(
          () => functionsMock.onError('my-error-message'),
        ).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      "only onSuccess is called once when login succeeds",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) {
        final event = LoginEvent.startLocalLogin(
          onError: functionsMock.onError,
          onSuccess: functionsMock.onSuccess,
        );
        bloc.add(event);
      },
      verify: (_) {
        verify(
          () => functionsMock.onSuccess(any<FakeUser>()),
        ).called(1);
        verifyNever(
          () => functionsMock.onError(any<String>()),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      "loginLocallyUC is called exactly once when login is possible",
      seed: () =>
          const LoginState.editing(email: 'email', password: 'password'),
      build: () => _buildLoginBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) {
        final event = LoginEvent.startLocalLogin(
          onError: functionsMock.onError,
          onSuccess: functionsMock.onSuccess,
        );
        bloc.add(event);
      },
      verify: (bloc) {
        verify(
          () => bloc.authenticationRepository.login(any<FakeLoginParams>()),
        ).called(1);
      },
    );
  });
  group('LoginBloc.canLogin', () {
    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false initially",
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );
    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false with null email",
      seed: () => const LoginState.editing(
        email: null,
        password: 'password',
      ),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );
    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false with null password",
      seed: () => const LoginState.editing(
        email: 'email',
        password: null,
      ),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false if state.loading is true",
      seed: () => const LoginState.editing(loading: true),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );
    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false with empty email",
      seed: () => const LoginState.editing(
        email: '',
        password: 'password',
      ),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns false with empty password",
      seed: () => const LoginState.editing(
        email: 'email',
        password: '',
      ),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, false),
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc.canLogin returns true with with non-null, non-empty email and password",
      seed: () => const LoginState.editing(
        email: 'email',
        password: 'password',
      ),
      build: () => _buildLoginBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canLogin, true),
    );
  });
}
