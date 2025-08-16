import 'dart:io';

import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/playlist_data.dart';
import '../view_model/playlist_view_model.dart';
import "package:path/path.dart";

class PlaylistSongs extends StatelessWidget {
  const PlaylistSongs({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {

        final playlist = vm.entityBeingVisualized;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 25,),
              onPressed: () {
                vm.setStackIndex(0);
              },
            ),
            actions: [
              IconButton(
                icon: SvgIcon(
                    assetName: 'assets/icons/Trash.svg',
                    color: theme.colorScheme.error,
                    size: 35
                ),
                onPressed: () => _deletePlaylist(context, playlist!, vm)
              ),
            ],
          ),
          body: playlist == null
              ? const Center(child: Text('Nenhuma playlist selecionada.'))
              : SingleChildScrollView(
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(playlist.title ?? '',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(playlist.description ?? '',
                  style: TextStyle(
                    color: theme.dividerColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criado por: ${playlist.author}',
                          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${playlist.duration} de duração',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Spacer(),
                    FloatingActionButton(
                      shape: CircleBorder(),
                      child: const Icon(Icons.play_arrow, size: 30),
                      onPressed: () {},
                    )

                  ],
                ),
                SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: playlist.songs?.length ?? 0,
                  itemBuilder: (context, index) {
                    final song = playlist.songs?[index];
                    return Card(
                      color: theme.cardColor,
                      child: InfoTile(
                          imageUrl: song?.coverUrl ?? '',
                          title: song?.title ?? '',
                          subtitle: song?.artist ?? '',
                          trailing: const Icon(Icons.more_vert, size: 20,),
                          onTap: () async {
                            vm.setStackIndex(2);
                          },
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePlaylist(BuildContext context, PlaylistData playlist, PlaylistViewModel vm) async {
    await vm.deletePlaylist(playlist.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        content: Text("Contact deleted"),
      ),
    );
  }
}