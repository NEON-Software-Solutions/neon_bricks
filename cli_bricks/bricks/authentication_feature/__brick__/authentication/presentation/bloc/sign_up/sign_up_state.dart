part of 'sign_up_bloc.dart';

@freezed
class SignUpState with _$SignUpState {
  //TODO adapt the editing state if needed
  const factory SignUpState.editing({
    String? username,
    String? email,
    String? password,
    @Default(false) bool isSubmitting,
  }) = _SignUpEditing;
}
