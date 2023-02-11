import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Comment {
  final String id;
  final String content;
  final String status;
  final String postId;
  final String postCreatedBy;
  final Map<String, dynamic> createdBy;
  final int createdAt;

  const Comment({
    required this.id,
    required this.content,
    required this.status,
    required this.postId,
    required this.postCreatedBy,
    required this.createdBy,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? content,
    String? status,
    String? postId,
    String? postCreatedBy,
    Map<String, dynamic>? createdBy,
    int? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      status: status ?? this.status,
      postId: postId ?? this.postId,
      postCreatedBy: postCreatedBy ?? this.postCreatedBy,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'status': status,
      'postId': postId,
      'postCreatedBy': postCreatedBy,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      status: map['status'] ?? '',
      postId: map['postId'] ?? '',
      postCreatedBy: map['postCreatedBy'] ?? '',
      createdBy: Map<String, dynamic>.from(map['createdBy']),
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(id: $id, content: $content, status: $status, postId: $postId, postCreatedBy: $postCreatedBy, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.content == content &&
        other.status == status &&
        other.postId == postId &&
        other.postCreatedBy == postCreatedBy &&
        mapEquals(other.createdBy, createdBy) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        status.hashCode ^
        postId.hashCode ^
        postCreatedBy.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode;
  }
}
