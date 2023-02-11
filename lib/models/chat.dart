import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Chat {
  final String id;
  final String lastMessage;
  final int createdAt;
  final int updatedAt;
  final List<String> users;
  final List<String> activeUsers;
  final List<String> usersTyping;
  final Map<String, dynamic> status;
  final Map<String, dynamic> profiles;

  const Chat({
    required this.id,
    required this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
    required this.activeUsers,
    required this.usersTyping,
    required this.status,
    required this.profiles,
  });

  Chat copyWith({
    String? id,
    String? lastMessage,
    int? createdAt,
    int? updatedAt,
    List<String>? users,
    List<String>? activeUsers,
    List<String>? usersTyping,
    Map<String, dynamic>? status,
    Map<String, dynamic>? profiles,
  }) {
    return Chat(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      users: users ?? this.users,
      activeUsers: activeUsers ?? this.activeUsers,
      usersTyping: usersTyping ?? this.usersTyping,
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastMessage': lastMessage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'users': users,
      'activeUsers': activeUsers,
      'usersTyping': usersTyping,
      'status': status,
      'profiles': profiles,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
      updatedAt: map['updatedAt']?.toInt() ?? 0,
      users: List<String>.from(map['users']),
      activeUsers: List<String>.from(map['activeUsers']),
      usersTyping: List<String>.from(map['usersTyping']),
      status: Map<String, dynamic>.from(map['status']),
      profiles: Map<String, dynamic>.from(map['profiles']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(id: $id, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt, users: $users, activeUsers: $activeUsers, usersTyping: $usersTyping, status: $status, profiles: $profiles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.id == id &&
        other.lastMessage == lastMessage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.users, users) &&
        listEquals(other.activeUsers, activeUsers) &&
        listEquals(other.usersTyping, usersTyping) &&
        mapEquals(other.status, status) &&
        mapEquals(other.profiles, profiles);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lastMessage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        users.hashCode ^
        activeUsers.hashCode ^
        usersTyping.hashCode ^
        status.hashCode ^
        profiles.hashCode;
  }
}
