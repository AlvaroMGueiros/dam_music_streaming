import 'dart:convert';
import 'package:dam_music_streaming/data/repositories/playlist_repository.dart';
import 'package:dio/dio.dart';

import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:http/http.dart';

import '../../ui/core/config/api_config.dart';

class PlaylistApiService {

  final Dio _dio;
  final String baseUrl;
  String? _token; //vou mover isso para um service de auth

  PlaylistApiService({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : _dio = dio ??
    Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10)
      )
    ) 
    {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && _token!.isNotEmpty) {
            options.headers['Autorization'] = 'Bearer $_token';
          }
          handler.next(options);
        }
      ));
    }

    Future<List<PlaylistDto>> fetchPlaylists() async{
    final response = await _dio.get('/playlists');
    final List<dynamic> jsonList = response.data;

    return jsonList
        .map((map) => PlaylistDto.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<PlaylistDto> getById(String id) async {
    final response = await _dio.get('/playlists/$id');
    return PlaylistDto.fromMap(response.data);
  }

  Future<PlaylistDto> create(PlaylistDto playlist) async {
    final response = await _dio.post('/playlists', data: playlist.toMap());
    return PlaylistDto.fromMap(response.data);
  }

  Future<PlaylistDto> update(String id, PlaylistDto playlist) async {
    final response = await _dio.put('/playlists/$id', data: playlist.toMap());
    return PlaylistDto.fromMap(response.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/playlists/$id');
  }
}