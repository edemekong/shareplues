import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Like {
  final String id;
  final String likedBy;
  final String postId;
  final String postCreatedBy;
  final int createdAt;

  const Like({
    required this.id,
    required this.likedBy,
    required this.postId,
    required this.postCreatedBy,
    required this.createdAt,
  });

  Like copyWith({
    String? id,
    String? likedBy,
    String? postId,
    String? postCreatedBy,
    int? createdAt,
  }) {
    return Like(
      id: id ?? this.id,
      likedBy: likedBy ?? this.likedBy,
      postId: postId ?? this.postId,
      postCreatedBy: postCreatedBy ?? this.postCreatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'likedBy': likedBy,
      'postId': postId,
      'postCreatedBy': postCreatedBy,
      'createdAt': createdAt,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'] ?? '',
      likedBy: map['likedBy'] ?? '',
      postId: map['postId'] ?? '',
      postCreatedBy: map['postCreatedBy'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Like(id: $id, likedBy: $likedBy, postId: $postId, postCreatedBy: $postCreatedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Like &&
        other.id == id &&
        other.likedBy == likedBy &&
        other.postId == postId &&
        other.postCreatedBy == postCreatedBy &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ likedBy.hashCode ^ postId.hashCode ^ postCreatedBy.hashCode ^ createdAt.hashCode;
  }
}
