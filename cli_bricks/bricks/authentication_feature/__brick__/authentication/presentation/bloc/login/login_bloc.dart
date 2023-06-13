import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:{{project_name}}/features/authentication/domain/use_cases/login_uc.dart';
import 'package:{{project_name}}/features/authentication/domain/use_cases/params/login_params.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUC loginLocallyUC;

  LoginBloc(
    this.loginLocallyUC,
  ) : super(const _LoginEditing()) {
    on<_StartLocalLogin>(_onLogin);
    on<_ChangeEmailLogin>(_onChangeEmail);
    on<_ChangePasswordLogin>(_onChangePassword);
  }

  void _onChangeEmail(_ChangeEmailLogin event, Emitter emit) {
    if (state.loading) return;
    emit(state.copyWith(email: event.email));
  }

  void _onChangePassword(_ChangePasswordLogin event, Emitter emit) {
    if (state.loading) return;
    emit(state.copyWith(password: event.password));
  }

  void _onLogin(_StartLocalLogin event, Emitter emit) async {
    if (canLogin) {
      emit(state.copyWith(loading: true));
      final loginParams = LoginParams(
        email: state.email!,
        password: state.password!,
      );
      final res = await loginLocallyUC(loginParams);
      res.fold(
        (l) {
          event.onError?.call(
            l.errorMessage ?? 'errorSomethingWentWrongPleaseTryAgain'.tr(),
          );
          emit(state.copyWith(loading: false));
        },
        (loggedInUser) => event.onSuccess?.call(loggedInUser),
      );
    }
  }

  bool get canLogin {
    if (state.loading) return false;
    return state.email != null &&
        state.email!.isNotEmpty &&
        state.password != null &&
        state.password!.isNotEmpty;
  }
}
