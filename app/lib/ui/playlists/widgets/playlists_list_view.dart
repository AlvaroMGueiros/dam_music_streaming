import "dart:io" show File;
import "package:path/path.dart";
import "package:dam_music_streaming/domain/models/playlist_data.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../data/services/playlist_service.dart";
import "../../core/ui/info_tile.dart";
import "../view_model/playlist_view_model.dart";

class PlaylistListView extends StatelessWidget{

  const PlaylistListView({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Minhas Playlists',
              style: const TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: theme.iconTheme.color, size: 25,),
                onPressed: () {
                  vm.startEditing();
                  vm.setStackIndex(1);
                },
              ),
            ],
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),

          body: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.playlists.length,
              itemBuilder: (context, index) {
                final playlist = vm.playlists[index];
                return Card(
                    color: theme.cardColor,
                    child: InfoTile(
                        imageUrl: playlist.urlCover ?? '',
                        title: playlist.title ?? '',
                        subtitle: playlist.author ?? '',
                        onTap: () {
                          vm.startView(playlist: playlist);
                          vm.setStackIndex(2);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showPlaylistActions(context, vm, playlist),
                        ),

                    ),
                );
              },
          ),
        );
      },
    );
  }

  //TODO: colocar para gerar um component de modal universal, ai poderemos abrir em varias telas.
  void _showPlaylistActions(BuildContext context, PlaylistViewModel vm, PlaylistData playlist) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: playlist.urlCover ?? '',
                title: playlist.title ?? '',
                subtitle: playlist.author ?? '',
              ),
              SizedBox(height: 20),
              _buildOptionItem(
                  context,
                  icon: Icons.person_outline,
                  text: 'Ver Author',
                  onTap: () {}),
              _buildOptionItem(
                  context,
                  icon: Icons.music_note_outlined,
                  text: 'Ver Musicas',
                  onTap: () {
                    Navigator.pop(context);
                    vm.startView(playlist: playlist);
                    vm.setStackIndex(2);
                  }),
              _buildOptionItem(
                context,
                icon: Icons.edit_outlined,
                text: 'Editar playlist',
                onTap: () {
                  Navigator.pop(context);
                  _editPlaylist(context, playlist, vm);
                },
              ),
              _buildOptionItem(
                  context,
                  icon: Icons.playlist_add,
                  text: 'Adicionar a fila de reprodução',
                  onTap: () {}),
              _buildOptionItem(
                context,
                btnColor: Colors.red,
                icon: Icons.delete_outline,
                text: 'Deletar playlist',
                onTap: () {
                  Navigator.pop(context);
                  vm.deletePlaylist(playlist.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
      BuildContext context,
      { required IconData icon,
        Color? btnColor,
        required String text,
        required VoidCallback onTap,
      }
      ){
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: btnColor,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),

      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 15),
            Text(text),
          ],
        ),
      ),
    );
  }

  //TODO: Vou usar S3, entao nao vai precisar dessa complexidade de path.
  Future<void> _editPlaylist(BuildContext context, PlaylistData playlist, PlaylistViewModel vm) async {
    final avatarFile = File(join(vm.docsDir.path, "playlist_cover"));
    if (avatarFile.existsSync()) avatarFile.deleteSync();
    //vm.startEditing(contact: await ContactsRepository.db.get(contact.id!));
    //var playlistDto = await PlaylistApiService.getById(playlist.id!);
    vm.startEditing(playlist: playlist);
    vm.setStackIndex(1);
  }
}