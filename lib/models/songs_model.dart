import 'dart:convert';

class Song {
  final String? songId;
  final String? songTitle;
  final String? songTitleInEnglish;
  final String? songText;
  final String? songCategory;
  final String? songAttribute;
  final String? songURL;
  final String? singerName;
  final bool? isEditable;
  final String? songDuration;
  Song({
    this.songId,
    this.songTitle,
    this.songTitleInEnglish,
    this.songText,
    this.songCategory,
    this.songAttribute,
    this.songURL,
    this.singerName,
    this.isEditable,
    this.songDuration,
  });

  Song copyWith({
    String? songId,
    String? songTitle,
    String? songTitleInEnglish,
    String? songText,
    String? songCategory,
    String? songAttribute,
    String? songURL,
    String? singerName,
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
      'isEditable': isEditable,
      'songDuration': songDuration,
    };
  }

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
      isEditable: map['isEditable'],
      songDuration: map['songDuration'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Song(songId: $songId, songTitle: $songTitle, songTitleInEnglish: $songTitleInEnglish, songText: $songText, songCategory: $songCategory, songAttribute: $songAttribute, songURL: $songURL, singerName: $singerName, isEditable: $isEditable, songDuration: $songDuration)';
  }

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
      isEditable.hashCode ^
      songDuration.hashCode;
  }
}
