import 'package:equatable/equatable.dart';

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.username,
    required this.email,
    required this.password,
  });
  final String username;
  final String email;
  final String password;

  @override
  List<Object?> get props => [username, email, password];
}
