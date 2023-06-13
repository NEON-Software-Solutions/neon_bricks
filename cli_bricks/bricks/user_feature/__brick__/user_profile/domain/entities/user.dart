import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

//TODO implement this (extend factory constructor with attributes
//you want and let freezed do the rest)
@freezed
class User with _$User {
  factory User({
    required String name,
    required String id,
    String? profileImageUrl,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
