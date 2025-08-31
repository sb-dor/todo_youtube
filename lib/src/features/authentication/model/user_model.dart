import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.surname,
  });

  final int id;
  final String name;
  final String email;
  final String? surname;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          surname == other.surname);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ email.hashCode ^ surname.hashCode;

  @override
  String toString() {
    return 'UserModel{'
        ' id: $id,'
        ' name: $name,'
        ' email: $email,'
        ' surname: $surname,'
        '}';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    ValueGetter<String?>? surname,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      surname: surname != null ? surname() : this.surname,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'surname': surname};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      surname: map['surname'] as String,
    );
  }
}
