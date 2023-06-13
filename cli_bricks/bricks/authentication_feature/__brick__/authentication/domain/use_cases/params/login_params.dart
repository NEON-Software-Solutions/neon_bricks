import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
