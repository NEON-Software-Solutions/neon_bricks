part of 'authentication_bloc.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.unauthenticated() = _Unauthenticated;
  const factory AuthenticationState.newUser() = _AuthNewUser;
  const factory AuthenticationState.loading() = _AuthLoading;
  const factory AuthenticationState.authenticated(
    User user,
  ) = _Authenticated;
}
