part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.changeEmail({required String email}) =
      _ChangeEmailLogin;
  const factory LoginEvent.changePassword({
    required String password,
  }) = _ChangePasswordLogin;
  const factory LoginEvent.startLocalLogin({
    Function(String)? onError,
    Function(User)? onSuccess,
  }) = _StartLocalLogin;
}
