import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

void main() {
  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc's initial state is unauthenticated",
    build: () => AuthenticationBloc(),
    verify: (bloc) =>
        expect(bloc.state, const AuthenticationState.unauthenticated()),
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "emits nothing when nothing is added",
    build: () => AuthenticationBloc(),
    expect: () => const [],
  );

  //TODO: implement this test
  blocTest<AuthenticationBloc, AuthenticationState>(
    "initialize emits unauthenticated",
    build: () => AuthenticationBloc(),
    act: (bloc) => bloc.add(const AuthenticationEvent.initialize()),
    expect: () => const [AuthenticationState.unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "updateUser correctly updates the current User",
    seed: () => AuthenticationState.authenticated(
      User(name: 'test1', id: '1'),
    ),
    build: () => AuthenticationBloc(),
    act: (bloc) => bloc.add(AuthenticationEvent.updateUser(
      User(name: 'test2', id: '2'),
    )),
    expect: () => [
      AuthenticationState.authenticated(
        User(name: 'test2', id: '2'),
      )
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "logout emits unauthenticated",
    seed: () => AuthenticationState.authenticated(
      User(name: 'test1', id: '1'),
    ),
    build: () => AuthenticationBloc(),
    act: (bloc) => bloc.add(const AuthenticationEvent.logout()),
    expect: () => const [AuthenticationState.unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "kickoutUser does nothing, if state was not authenticated",
    build: () => AuthenticationBloc(),
    act: (bloc) => bloc.kickOutUser(),
    expect: () => [],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "kickoutUser emits unauthenticated, if state was authenticated",
    seed: () => AuthenticationState.authenticated(
      User(name: 'test1', id: '1'),
    ),
    build: () => AuthenticationBloc(),
    act: (bloc) => bloc.kickOutUser(),
    expect: () => const [AuthenticationState.unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc.authenticatedUser returns null, if state is not authenticated",
    build: () => AuthenticationBloc(),
    verify: (bloc) => expect(bloc.authenticatedUser, isNull),
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc.authenticatedUser returns current User, if state is authenticated",
    seed: () => AuthenticationState.authenticated(
      User(name: 'test1', id: '1'),
    ),
    build: () => AuthenticationBloc(),
    verify: (bloc) => expect(
      bloc.authenticatedUser,
      User(name: 'test1', id: '1'),
    ),
  );
}
