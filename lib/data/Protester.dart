import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Protester {
  final String phoneNumber;

  Protester({required this.phoneNumber});

  factory Protester.fromJson(Map<String, dynamic> json) => Protester(
        phoneNumber: json['phoneNumber'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
      };
}
