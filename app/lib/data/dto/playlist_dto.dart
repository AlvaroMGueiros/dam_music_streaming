import 'package:dam_music_streaming/data/dto/song_dto.dart';

import '../../domain/models/playlist_data.dart';

class PlaylistDto {
  String? id;
  String? title;
  String? description;
  String? urlCover;
  int? numSongs;
  String? author;
  String? duration;
  List<SongDto> songs;

  PlaylistDto({
    this.id,
    this.title,
    this.description,
    this.urlCover,
    this.numSongs,
    this.author,
    this.duration,
    this.songs = const [],
  });

  factory PlaylistDto.fromMap(Map<String, dynamic> map) {
    return PlaylistDto(
      id: map['id'] ?? '0',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      urlCover: map['urlCover'] ?? '',
      numSongs: map['numSongs'] ?? 0,
      author: map['author'] ?? '',
      duration: map['duration'] ?? '',
      songs: (map['songs'] as List<dynamic>?)
          ?.map((song) => SongDto.fromMap(song as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
  factory PlaylistDto.fromData(PlaylistData data) {
    return PlaylistDto(
      id: data.id ?? '',
      title: data.title ?? '',
      description: data.description ?? '',
      urlCover: data.urlCover ?? '',
      numSongs: data.numSongs ?? 0, //talvez normalizar, para pegar songs.len
      author: data.author ?? '',
      duration: data.duration ?? '',
      songs: data.songs?.map((songData) => SongDto.fromData(songData)).toList()
          ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urlCover': urlCover,
      'numSongs': numSongs,
      'author': author,
      'duration': duration,
      'songs': songs.map((song) => song.toMap()).toList(),
    };
  }
}