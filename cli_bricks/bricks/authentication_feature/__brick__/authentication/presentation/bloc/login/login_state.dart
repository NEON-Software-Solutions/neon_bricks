part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  //TODO adapt the editing state if needed
  const factory LoginState.editing({
    String? email,
    String? password,
    @Default(false) bool loading,
  }) = _LoginEditing;
}
