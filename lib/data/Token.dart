import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Token {
  final String uid;
  final String phoneNumber;

  Token({required this.uid, required this.phoneNumber});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        uid: json['uid'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'phoneNumber': phoneNumber,
      };
}
