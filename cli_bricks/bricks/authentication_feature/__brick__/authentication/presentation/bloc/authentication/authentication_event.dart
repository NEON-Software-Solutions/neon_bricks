part of 'authentication_bloc.dart';

//TODO: adapt these events

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.initialize() = _InitializeAuth;
  const factory AuthenticationEvent.updateUser(User user) = _UpdateUser;
  const factory AuthenticationEvent.logout() = _LogoutUser;
}
