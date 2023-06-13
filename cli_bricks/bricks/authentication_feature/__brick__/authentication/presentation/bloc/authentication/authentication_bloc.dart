import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';{{#toast_service}}
import 'package:easy_localization/easy_localization.dart';

import 'package:{{project_name}}/core/core.dart';
import 'package:{{project_name}}/injection.dart';{{/toast_service}}
import 'package:{{project_name}}/features/user_profile/domain/entities/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authentication_bloc.freezed.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.unauthenticated()) {
    on<_InitializeAuth>(_onInit);
    on<_UpdateUser>(_onUpdateUser);
    on<_LogoutUser>(_onLogout);
  }

  //TODO: implement the handlers
  void _onInit(_InitializeAuth event, Emitter emit) =>
      emit(const AuthenticationState.unauthenticated());

  void _onUpdateUser(_UpdateUser event, Emitter emit) => emit(
        AuthenticationState.authenticated(event.user),
      );
      
  void _onLogout(_LogoutUser event, Emitter emit) => emit(
        const AuthenticationState.unauthenticated(),
      );

  void kickOutUser() {
    state.maybeMap(
      orElse: () {},
      authenticated: (_) {
        add(const AuthenticationEvent.logout());
        {{#toast_service}}
        if (cachedContext != null) {
          getIt<ToastService>()
              .showErrorToast(cachedContext!, 'errorYouHaveBeenLoggedOut'.tr());
        }{{/toast_service}}
      },
    );
  }

   User? get authenticatedUser => state.maybeMap(
        orElse: () => null,
        authenticated: (state) => state.user,
      );
}
