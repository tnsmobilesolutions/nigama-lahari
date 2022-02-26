import 'dart:convert';

class SongsModel {
  final String? songId;
  final String? songTitle;
  final String? songText;
  final String? songCategory;
  final String? songAttribute;
  final String? songURL;
  final String? singerName;
  final bool? isEditable;
  final double? songDuration;
  SongsModel({
    this.songId,
    this.songTitle,
    this.songText,
    this.songCategory,
    this.songAttribute,
    this.songURL,
    this.singerName,
    this.isEditable,
    this.songDuration,
  });

  SongsModel copyWith({
    String? songId,
    String? songTitle,
    String? songText,
    String? songCategory,
    String? songAttribute,
    String? songURL,
    String? singerName,
    bool? isEditable,
    double? songDuration,
  }) {
    return SongsModel(
      songId: songId ?? this.songId,
      songTitle: songTitle ?? this.songTitle,
      songText: songText ?? this.songText,
      songCategory: songCategory ?? this.songCategory,
      songAttribute: songAttribute ?? this.songAttribute,
      songURL: songURL ?? this.songURL,
      singerName: singerName ?? this.singerName,
      isEditable: isEditable ?? this.isEditable,
      songDuration: songDuration ?? this.songDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'songTitle': songTitle,
      'songText': songText,
      'songCategory': songCategory,
      'songAttribute': songAttribute,
      'songURL': songURL,
      'singerName': singerName,
      'isEditable': isEditable,
      'songDuration': songDuration,
    };
  }

  factory SongsModel.fromMap(Map<String, dynamic> map) {
    return SongsModel(
      songId: map['songId'],
      songTitle: map['songTitle'],
      songText: map['songText'],
      songCategory: map['songCategory'],
      songAttribute: map['songAttribute'],
      songURL: map['songURL'],
      singerName: map['singerName'],
      isEditable: map['isEditable'],
      songDuration: map['songDuration']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SongsModel.fromJson(String source) =>
      SongsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SongsModel(songId: $songId, songTitle: $songTitle, songText: $songText, songCategory: $songCategory, songAttribute: $songAttribute, songURL: $songURL, singerName: $singerName, isEditable: $isEditable, songDuration: $songDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SongsModel &&
        other.songId == songId &&
        other.songTitle == songTitle &&
        other.songText == songText &&
        other.songCategory == songCategory &&
        other.songAttribute == songAttribute &&
        other.songURL == songURL &&
        other.singerName == singerName &&
        other.isEditable == isEditable &&
        other.songDuration == songDuration;
  }

  @override
  int get hashCode {
    return songId.hashCode ^
        songTitle.hashCode ^
        songText.hashCode ^
        songCategory.hashCode ^
        songAttribute.hashCode ^
        songURL.hashCode ^
        singerName.hashCode ^
        isEditable.hashCode ^
        songDuration.hashCode;
  }
}
