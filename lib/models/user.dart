import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class User {
  final String uid;
  final String name;
  final String handle;

  final String email;
  final String profileImageUrl;
  final bool active;

  final int createdAt;
  final int updatedAt;

  const User({
    required this.uid,
    required this.name,
    required this.handle,
    required this.email,
    required this.profileImageUrl,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? uid,
    String? name,
    String? handle,
    String? email,
    String? profileImageUrl,
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'handle': handle,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'active': active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      handle: map['handle'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
      createdAt: map['createdAt']?.toInt() ?? 0,
      updatedAt: map['updatedAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, handle: $handle, email: $email, profileImageUrl: $profileImageUrl, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.handle == handle &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.active == active &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        handle.hashCode ^
        email.hashCode ^
        profileImageUrl.hashCode ^
        active.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
