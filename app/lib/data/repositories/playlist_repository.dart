import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/ui/playlists/widgets/playlists_view.dart';

import '../../domain/models/playlist_data.dart';
import '../dto/playlist_dto.dart';

class PlaylistRepository {
  final PlaylistApiService api = PlaylistApiService();

  Future<List<PlaylistData>> getPlaylists() async {
    final List<PlaylistDto> playlists = await api.fetchPlaylists();
    return playlists.map((dto) => PlaylistData.fromDto(dto)).toList();
  }

  Future<PlaylistData> getPlaylistById(String id) async {
    final PlaylistDto dto = await api.getById(id);
    return PlaylistData.fromDto(dto);
  }

  Future<PlaylistData> createPlaylist(PlaylistData playlist) async {
    final PlaylistDto playlistDto = PlaylistDto.fromData(playlist);
    final PlaylistDto createdDto = await api.create(playlistDto);
    return PlaylistData.fromDto(createdDto);
  }

  Future<PlaylistData> updatePlaylist(String id, PlaylistData playlist) async {
    final PlaylistDto playlistDto = PlaylistDto.fromData(playlist);
    final PlaylistDto updatedDto = await api.update(id, playlistDto);
    return PlaylistData.fromDto(updatedDto);
  }

  Future<void> deletePlaylist(String id) async {
    await api.delete(id);
  }

}