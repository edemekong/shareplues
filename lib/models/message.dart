import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Message {
  final String id;
  final String uid;
  final String replyingToId;
  final String content;
  final String status;
  final Map<String, dynamic> preview;
  final int createdAt;
  final int updatedAt;

  const Message({
    required this.id,
    required this.uid,
    required this.replyingToId,
    required this.content,
    required this.status,
    required this.preview,
    required this.createdAt,
    required this.updatedAt,
  });

  Message copyWith({
    String? id,
    String? uid,
    String? replyingToId,
    String? content,
    String? status,
    Map<String, dynamic>? preview,
    int? createdAt,
    int? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      replyingToId: replyingToId ?? this.replyingToId,
      content: content ?? this.content,
      status: status ?? this.status,
      preview: preview ?? this.preview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'replyingToId': replyingToId,
      'content': content,
      'status': status,
      'preview': preview,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      replyingToId: map['replyingToId'] ?? '',
      content: map['content'] ?? '',
      status: map['status'] ?? '',
      preview: Map<String, dynamic>.from(map['preview']),
      createdAt: map['createdAt']?.toInt() ?? 0,
      updatedAt: map['updatedAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, uid: $uid, replyingToId: $replyingToId, content: $content, status: $status, preview: $preview, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.uid == uid &&
        other.replyingToId == replyingToId &&
        other.content == content &&
        other.status == status &&
        mapEquals(other.preview, preview) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        replyingToId.hashCode ^
        content.hashCode ^
        status.hashCode ^
        preview.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
