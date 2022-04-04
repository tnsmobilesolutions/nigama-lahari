import 'dart:convert';

class Song {
  Song({
    this.songId,
    this.songTitle,
    this.songTitleInEnglish,
    this.songText,
    this.songCategory,
    this.songAttribute,
    this.songURL,
    this.singerName,
    this.uploadedBy,
    this.isEditable,
    this.songDuration,
  });

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      songId: map['songId'],
      songTitle: map['songTitle'],
      songTitleInEnglish: map['songTitleInEnglish'],
      songText: map['songText'],
      songCategory: map['songCategory'],
      songAttribute: map['songAttribute'],
      songURL: map['songURL'],
      singerName: map['singerName'],
      uploadedBy: map['uploadedBy'],
      isEditable: map['isEditable'],
      songDuration: map['songDuration'],
    );
  }

  final bool? isEditable;
  final String? singerName;
  final String? songAttribute;
  final String? songCategory;
  final String? songDuration;
  final String? songId;
  final String? songText;
  final String? songTitle;
  final String? songTitleInEnglish;
  final String? songURL;
  final String? uploadedBy;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song &&
        other.songId == songId &&
        other.songTitle == songTitle &&
        other.songTitleInEnglish == songTitleInEnglish &&
        other.songText == songText &&
        other.songCategory == songCategory &&
        other.songAttribute == songAttribute &&
        other.songURL == songURL &&
        other.singerName == singerName &&
        other.uploadedBy == uploadedBy &&
        other.isEditable == isEditable &&
        other.songDuration == songDuration;
  }

  @override
  int get hashCode {
    return songId.hashCode ^
        songTitle.hashCode ^
        songTitleInEnglish.hashCode ^
        songText.hashCode ^
        songCategory.hashCode ^
        songAttribute.hashCode ^
        songURL.hashCode ^
        singerName.hashCode ^
        uploadedBy.hashCode ^
        isEditable.hashCode ^
        songDuration.hashCode;
  }

  @override
  String toString() {
    return 'Song(songId: $songId, songTitle: $songTitle, songTitleInEnglish: $songTitleInEnglish, songText: $songText, songCategory: $songCategory, songAttribute: $songAttribute, songURL: $songURL, singerName: $singerName, uploadedBy: $uploadedBy, isEditable: $isEditable, songDuration: $songDuration)';
  }

  Song copyWith({
    String? songId,
    String? songTitle,
    String? songTitleInEnglish,
    String? songText,
    String? songCategory,
    String? songAttribute,
    String? songURL,
    String? singerName,
    String? uploadedBy,
    bool? isEditable,
    String? songDuration,
  }) {
    return Song(
      songId: songId ?? this.songId,
      songTitle: songTitle ?? this.songTitle,
      songTitleInEnglish: songTitleInEnglish ?? this.songTitleInEnglish,
      songText: songText ?? this.songText,
      songCategory: songCategory ?? this.songCategory,
      songAttribute: songAttribute ?? this.songAttribute,
      songURL: songURL ?? this.songURL,
      singerName: singerName ?? this.singerName,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isEditable: isEditable ?? this.isEditable,
      songDuration: songDuration ?? this.songDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'songTitle': songTitle,
      'songTitleInEnglish': songTitleInEnglish,
      'songText': songText,
      'songCategory': songCategory,
      'songAttribute': songAttribute,
      'songURL': songURL,
      'singerName': singerName,
      'uploadedBy': uploadedBy,
      'isEditable': isEditable,
      'songDuration': songDuration,
    };
  }

  String toJson() => json.encode(toMap());
}
