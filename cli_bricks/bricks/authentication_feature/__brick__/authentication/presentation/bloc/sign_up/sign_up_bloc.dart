import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/features/authentication/domain/params/sign_up_params.dart';
import 'package:{{project_name}}/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:{{project_name}}/features/user_profile/domain/entities/user.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';
part 'sign_up_bloc.freezed.dart';

@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this.authenticationRepository) : super(const _SignUpEditing()) {
    on<_ChangeEmailSignUp>(_onChangeEmail);
    on<_ChangeUsernameSignup>(_onChangeUsername);
    on<_ChangePasswordSignup>(_onChangePassword);
    on<_SignUp>(_onSignUp);
  }

  final AuthenticationRepository authenticationRepository;

  void _onChangeUsername(
    _ChangeUsernameSignup event,
    Emitter<SignUpState> emit,
  ) {
    if (state.isSubmitting) return;
    emit(state.copyWith(username: event.username));
  }

  void _onChangeEmail(
    _ChangeEmailSignUp event,
    Emitter<SignUpState> emit,
  ) {
    if (state.isSubmitting) return;
    emit(state.copyWith(email: event.email));
  }

  void _onChangePassword(
    _ChangePasswordSignup event,
    Emitter<SignUpState> emit,
  ) {
    if (state.isSubmitting) return;
    emit(state.copyWith(password: event.password));
  }

  void _onSignUp(
    _SignUp event,
    Emitter<SignUpState> emit,
  ) async {
    if (canSignup) {
      emit(state.copyWith(isSubmitting: true));
      final signUpParams = SignUpParams(
        username: state.username!,
        email: state.email!,
        password: state.password!,
      );
      final res = await authenticationRepository.signUp(signUpParams);
      res.fold(
        (l) {
          event.onError?.call(
            l.errorMessage ?? 'errorSomethingWentWrongPleaseTryAgain'.tr(),
          );
          emit(state.copyWith(isSubmitting: false));
        },
        (r) => event.onSuccess?.call(r),
      );
    }
  }

  bool get canSignup {
    if (state.isSubmitting) return false;
    return state.username != null &&
        state.username!.isNotEmpty &&
        state.email != null &&
        state.email!.contains('@') &&
        state.email!.contains('.') &&
        state.email!.length > 3 &&
        state.password != null &&
        state.password!.isNotEmpty;
  }
}
