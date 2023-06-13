part of 'sign_up_bloc.dart';

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.changeEmail({required String email}) =
      _ChangeEmailSignUp;
  const factory SignUpEvent.changePassword({
    required String password,
  }) = _ChangePasswordSignup;
  const factory SignUpEvent.changeUsername({
    required String username,
  }) = _ChangeUsernameSignup;
  const factory SignUpEvent.signUp({
    Function(String)? onError,
    Function(User)? onSuccess,
  }) = _SignUp;
}
