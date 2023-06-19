import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/authentication/domain/params/params.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockAuthenticationRepo extends Mock implements AuthenticationRepository {}

class EventFunctions {
  onError(String string) {}
  onSuccess(User user) {}
}

class MockFunctions extends Mock implements EventFunctions {}

class FakeSignUpParams extends Fake implements SignUpParams {}

class FakeUser extends Fake implements User {}

SignUpBloc _buildSignUpBlocWithMockAuthRepo(
    {Either<Failure, User>? mockReturnValue}) {
  final mockAuthRepo = MockAuthenticationRepo();
  if (mockReturnValue != null) {
    when(
      () => mockAuthRepo.signUp(any<FakeSignUpParams>()),
    ).thenAnswer((_) async => mockReturnValue);
  }

  return SignUpBloc(mockAuthRepo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSignUpParams());
    registerFallbackValue(FakeUser());
  });
  blocTest<SignUpBloc, SignUpState>(
    "SignUpBloc's initial state is an empty editing State",
    build: () {
      final mockAuthRepo = MockAuthenticationRepo();
      return SignUpBloc(mockAuthRepo);
    },
    verify: (bloc) {
      expect(bloc.state.isSubmitting, false);
      expect(bloc.state.email, isNull);
      expect(bloc.state.password, isNull);
      expect(bloc.state.username, isNull);
    },
  );
  blocTest<SignUpBloc, SignUpState>(
    "SignUpBloc emits nothing when nothing is added",
    build: () {
      final mockAuthRepo = MockAuthenticationRepo();
      return SignUpBloc(mockAuthRepo);
    },
    expect: () => const [],
  );

  group('onChangeUsername', () {
    blocTest<SignUpBloc, SignUpState>(
      "onChangeUsername emits nothing if state.isSubmitting",
      seed: () => const SignUpState.editing(isSubmitting: true),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changeUsername(username: 'username'))),
      expect: () => [],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangeUsername updates username",
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changeUsername(username: 'username'))),
      expect: () => [
        const SignUpState.editing(
          password: null,
          isSubmitting: false,
          email: null,
          username: 'username',
        )
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangeUsername updates username",
      seed: () => const SignUpState.editing(password: 'password'),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changeUsername(username: 'username'))),
      expect: () => [
        const SignUpState.editing(
          password: 'password',
          email: null,
          isSubmitting: false,
          username: 'username',
        )
      ],
    );
  });

  group('onChangeEmail', () {
    blocTest<SignUpBloc, SignUpState>(
      "onChangeEmail emits nothing if state.isSubmitting",
      seed: () => const SignUpState.editing(isSubmitting: true),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const SignUpEvent.changeEmail(email: 'email'))),
      expect: () => [],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangeEmail updates email",
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const SignUpEvent.changeEmail(email: 'email'))),
      expect: () => [
        const SignUpState.editing(
          password: null,
          isSubmitting: false,
          email: 'email',
        )
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangeEmail only updates email",
      seed: () => const SignUpState.editing(password: 'password'),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) => bloc.add(const SignUpEvent.changeEmail(email: 'email'))),
      expect: () => [
        const SignUpState.editing(
          password: 'password',
          isSubmitting: false,
          email: 'email',
        )
      ],
    );
  });

  group('onChangePassword', () {
    blocTest<SignUpBloc, SignUpState>(
      "onChangePassword emits nothing if state.isSubmitting",
      seed: () => const SignUpState.editing(isSubmitting: true),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changePassword(password: 'password'))),
      expect: () => [],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangePassword updates password",
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changePassword(password: 'password'))),
      expect: () => [
        const SignUpState.editing(
          password: 'password',
          isSubmitting: false,
          email: null,
        )
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onChangePassword only updates password",
      seed: () => const SignUpState.editing(email: 'email'),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      act: ((bloc) =>
          bloc.add(const SignUpEvent.changePassword(password: 'password'))),
      expect: () => [
        const SignUpState.editing(
          password: 'password',
          isSubmitting: false,
          email: 'email',
        )
      ],
    );
  });

  group('onSignUp', () {
    final functionsMock = MockFunctions();
    blocTest<SignUpBloc, SignUpState>(
      "onSignUp emits nothing when SignUpBloc.canSignUp is false",
      build: () {
        final bloc = MockSignUpBloc();
        when(() => bloc.canSignup).thenReturn(false);
        return bloc;
      },
      act: (bloc) => bloc.add(const SignUpEvent.signUp()),
      expect: () => const [],
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "onSignUp emits original state when sign up fails",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure())),
      act: (bloc) => bloc.add(const SignUpEvent.signUp()),
      expect: () => const [
        SignUpState.editing(
          email: 'valid@email.com',
          password: 'password',
          username: 'username',
          isSubmitting: true,
        ),
        SignUpState.editing(
          email: 'valid@email.com',
          password: 'password',
          username: 'username',
          isSubmitting: false,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "onSignUp emits previous state with isSubmitting = true when signUp succeeds",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) => bloc.add(const SignUpEvent.signUp()),
      expect: () => const [
        SignUpState.editing(
          email: 'valid@email.com',
          password: 'password',
          username: 'username',
          isSubmitting: true,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "only onError is called once when signup fails",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure())),
      act: (bloc) => bloc.add(SignUpEvent.signUp(
        onError: functionsMock.onError,
        onSuccess: functionsMock.onSuccess,
      )),
      verify: (_) {
        verify(
          () => functionsMock.onError(any<String>()),
        ).called(1);
        verifyNever(
          () => functionsMock.onSuccess(any<FakeUser>()),
        );
      },
    );

    blocTest<SignUpBloc, SignUpState>(
      "onError is called with given failure error message when signup fails",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: const Left(Failure('my-error-message'))),
      act: (bloc) => bloc.add(SignUpEvent.signUp(
        onError: functionsMock.onError,
        onSuccess: functionsMock.onSuccess,
      )),
      verify: (_) {
        verify(
          () => functionsMock.onError('my-error-message'),
        ).called(1);
      },
    );

    blocTest<SignUpBloc, SignUpState>(
      "only onSuccess is called once when signup succeeds",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) => bloc.add(SignUpEvent.signUp(
        onError: functionsMock.onError,
        onSuccess: functionsMock.onSuccess,
      )),
      verify: (_) {
        verify(
          () => functionsMock.onSuccess(any<FakeUser>()),
        ).called(1);
        verifyNever(
          () => functionsMock.onError(any<String>()),
        );
      },
    );

    blocTest<SignUpBloc, SignUpState>(
      "signUpUC is called exactly once when signup is possible",
      seed: () => const SignUpState.editing(
          email: 'valid@email.com', password: 'password', username: 'username'),
      build: () => _buildSignUpBlocWithMockAuthRepo(
          mockReturnValue: Right(User(name: 'name', id: 'id'))),
      act: (bloc) => bloc.add(SignUpEvent.signUp(
        onError: functionsMock.onError,
        onSuccess: functionsMock.onSuccess,
      )),
      verify: (bloc) {
        verify(
          () => bloc.authenticationRepository.signUp(any<FakeSignUpParams>()),
        ).called(1);
      },
    );
  });
  group('SignUpBloc.canSignUp', () {
    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false initially",
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false if state.isSubmitting is true",
      seed: () => const SignUpState.editing(isSubmitting: true),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );
    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with null email",
      seed: () => const SignUpState.editing(
        email: null,
        password: 'password',
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with null password",
      seed: () => const SignUpState.editing(
        email: null,
        password: 'password',
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );
    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with null username",
      seed: () => const SignUpState.editing(
        email: 'email',
        password: 'password',
        username: null,
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with empty username",
      seed: () => const SignUpState.editing(
        username: '',
        password: 'password',
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with empty password",
      seed: () => const SignUpState.editing(
        email: 'email',
        password: '',
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with email too short",
      seed: () => const SignUpState.editing(
          email: 'ema', password: 'password', username: 'user'),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns false with email incorrect",
      seed: () => const SignUpState.editing(
          email: 'thisisaninvalid@email',
          password: 'password',
          username: 'user'),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, false),
    );

    blocTest<SignUpBloc, SignUpState>(
      "SignUpBloc.canSignup returns true with with non-null, non-empty username and password and valid email",
      seed: () => const SignUpState.editing(
        email: 'my-valid@email.com',
        username: 'username',
        password: 'password',
      ),
      build: () => _buildSignUpBlocWithMockAuthRepo(),
      verify: (bloc) => expect(bloc.canSignup, true),
    );
  });
}
