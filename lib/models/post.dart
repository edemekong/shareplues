import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String postId;
  final Map<String, dynamic> createdBy;
  final List<MediaAttachment> attachments;
  final String caption;
  final int likes;
  final int comments;
  final int createdAt;
  final int updated;

  const Post({
    required this.postId,
    required this.createdBy,
    required this.attachments,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updated,
  });

  Post copyWith({
    String? postId,
    Map<String, dynamic>? createdBy,
    List<MediaAttachment>? attachments,
    String? caption,
    int? likes,
    int? comments,
    int? createdAt,
    int? updated,
  }) {
    return Post(
      postId: postId ?? this.postId,
      createdBy: createdBy ?? this.createdBy,
      attachments: attachments ?? this.attachments,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'createdBy': createdBy,
      'attachments': attachments.map((x) => x.toMap()).toList(),
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
      'updated': updated,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      createdBy: Map<String, dynamic>.from(map['createdBy']),
      attachments: List<MediaAttachment>.from(map['attachments']?.map((x) => MediaAttachment.fromMap(x))),
      caption: map['caption'] ?? '',
      likes: map['likes']?.toInt() ?? 0,
      comments: map['comments']?.toInt() ?? 0,
      createdAt: map['createdAt']?.toInt() ?? 0,
      updated: map['updated']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(postId: $postId, createdBy: $createdBy, attachments: $attachments, caption: $caption, likes: $likes, comments: $comments, createdAt: $createdAt, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.postId == postId &&
        mapEquals(other.createdBy, createdBy) &&
        listEquals(other.attachments, attachments) &&
        other.caption == caption &&
        other.likes == likes &&
        other.comments == comments &&
        other.createdAt == createdAt &&
        other.updated == updated;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        createdBy.hashCode ^
        attachments.hashCode ^
        caption.hashCode ^
        likes.hashCode ^
        comments.hashCode ^
        createdAt.hashCode ^
        updated.hashCode;
  }
}

@immutable
class MediaAttachment {
  final String id;
  final String contentType;
  final String filePath;
  final String thumbPath;
  final String thumbLink;
  final String fileLink;
  const MediaAttachment({
    required this.id,
    required this.contentType,
    required this.filePath,
    required this.thumbPath,
    required this.thumbLink,
    required this.fileLink,
  });

  MediaAttachment copyWith({
    String? id,
    String? contentType,
    String? filePath,
    String? thumbPath,
    String? thumbLink,
    String? fileLink,
  }) {
    return MediaAttachment(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      filePath: filePath ?? this.filePath,
      thumbPath: thumbPath ?? this.thumbPath,
      thumbLink: thumbLink ?? this.thumbLink,
      fileLink: fileLink ?? this.fileLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contentType': contentType,
      'filePath': filePath,
      'thumbPath': thumbPath,
      'thumbLink': thumbLink,
      'fileLink': fileLink,
    };
  }

  factory MediaAttachment.fromMap(Map<String, dynamic> map) {
    return MediaAttachment(
      id: map['id'] ?? '',
      contentType: map['contentType'] ?? '',
      filePath: map['filePath'] ?? '',
      thumbPath: map['thumbPath'] ?? '',
      thumbLink: map['thumbLink'] ?? '',
      fileLink: map['fileLink'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaAttachment.fromJson(String source) => MediaAttachment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MediaAttachment(id: $id, contentType: $contentType, filePath: $filePath, thumbPath: $thumbPath, thumbLink: $thumbLink, fileLink: $fileLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MediaAttachment &&
        other.id == id &&
        other.contentType == contentType &&
        other.filePath == filePath &&
        other.thumbPath == thumbPath &&
        other.thumbLink == thumbLink &&
        other.fileLink == fileLink;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contentType.hashCode ^
        filePath.hashCode ^
        thumbPath.hashCode ^
        thumbLink.hashCode ^
        fileLink.hashCode;
  }
}
