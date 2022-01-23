import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'uid')
  String? uid;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'first_name')
  String? firstName;

  @JsonKey(name: 'last_name')
  String? lastName;

  UserModel({this.uid, this.email, this.firstName, this.lastName});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserModel.fromJson(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['first_name'],
        lastName: map['last_name']);
  }
  Map<String, dynamic> toJson(UserModel instance) => <String, dynamic>{
        'uid': uid,
        'email': email,
        'first_name': firstName ?? false,
        'last_name': lastName,
      };
}
