import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class User {
  final String uid;
  final String name;
  final String email;
  final String profileImageUrl;
  final bool active;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.active,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImageUrl,
    bool? active,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'active': active,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, profileImageUrl: $profileImageUrl, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.active == active;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ email.hashCode ^ profileImageUrl.hashCode ^ active.hashCode;
  }
}
