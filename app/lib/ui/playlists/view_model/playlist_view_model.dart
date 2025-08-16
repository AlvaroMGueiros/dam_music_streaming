import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import "package:path/path.dart";

import '../../../data/repositories/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {

  final PlaylistRepository repository = PlaylistRepository();

  int _stackIndex = 0;
  List<PlaylistData> _playlists = [];
  PlaylistData? entityBeingVisualized;
  PlaylistData? entityBeingEdited;
  final Directory docsDir;

  PlaylistViewModel(this.docsDir);

  Future<void> loadPlaylists() async {
    try {
      _playlists = await repository.getPlaylists();
      print(_playlists);
    } catch (e) {
      print('error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> savePlaylist() async {
    if (entityBeingEdited == null) return;

    try {
      PlaylistData savedPlaylist;
      if (entityBeingEdited!.id == null || entityBeingEdited!.id!.isEmpty) {
        savedPlaylist = await repository.createPlaylist(entityBeingEdited!);
      } else {
        savedPlaylist = await repository.updatePlaylist(
            entityBeingEdited!.id!, entityBeingEdited!);
      }
      _renameTempCover(savedPlaylist.id!);
    } catch (e) {
      print('error ao salvar: $e');
    } finally {
      await loadPlaylists();
      setStackIndex(0);
    }
  }

  Future<void> deletePlaylist(String id) async {
    if (entityBeingVisualized == null) return;

    try {
      final avatarFile = File(join(docsDir.path, id.toString()));
      if (avatarFile.existsSync()) avatarFile.deleteSync();

      await repository.deletePlaylist(id);
      await loadPlaylists();
    } catch (e) {
      print('error ao deletar: $e');
    } finally {
      setStackIndex(0);
    }
  }

  int get stackIndex => _stackIndex;
  List<PlaylistData> get playlists => _playlists;

  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }

  void startEditing({PlaylistData? playlist}) {
    entityBeingEdited = playlist ??
        PlaylistData(
            title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void startView({PlaylistData? playlist}) {
    entityBeingVisualized = playlist ??
        PlaylistData(
            title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void _renameTempCover(String id) {
    final coverFile = File(join(docsDir.path, "playlist_cover"));
    if (coverFile.existsSync()) {
      coverFile.renameSync(join(docsDir.path, id.toString()));
    }
  }

  void triggerRebuild() {
    notifyListeners();
  }
}