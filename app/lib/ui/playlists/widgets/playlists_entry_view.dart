import "dart:io";
import "package:path/path.dart";
import "package:dam_music_streaming/ui/core/ui/input_global.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../../core/ui/image_edit.dart";
import "../view_model/playlist_view_model.dart";

class PlaylistEntryView extends StatelessWidget{

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        if (vm.entityBeingEdited != null) {
          _nameController.text = vm.entityBeingEdited!.title ?? '';
          _descController.text = vm.entityBeingEdited!.description ?? '';
        }
        File coverPlaylistFile = File(join(vm.docsDir.path, "playlist_cover")); //vamos salvar localmente e colocar e mapear com banco

        if (!coverPlaylistFile.existsSync() && vm.entityBeingEdited?.id != null) {
          coverPlaylistFile = File(join(vm.docsDir.path, vm.entityBeingEdited!.id));
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                FocusScope.of(context).unfocus();
                vm.setStackIndex(0);
              },
            ),
            centerTitle: true,
            title: const Text('Nova Playlist'),
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Criar playlist"),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_outlined, size: 25,),
                ],
              ),
              onPressed: () => _save(context, vm),
            ),
          ),
          body: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageRoundEdit(
                            coverPlaylistFile: coverPlaylistFile,
                            onTap: () => _selectCoverPlaylist(context, vm),
                          ),
                          const SizedBox(height: 32),
                          CustomInputField(
                            controller: _nameController,
                            hintText: 'Nome da Playlist',
                            iconData: Icons.music_note,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'O nome é obrigatório.';
                              }
                              return null;
                            },
                            onChanged: (v) => vm.entityBeingEdited!.title = v,
                          ),
                          const SizedBox(height: 20),
                          CustomInputField(
                            controller: _descController,
                            hintText: 'Descrição',
                            iconData: Icons.description,
                            onChanged: (v) => vm.entityBeingEdited!.description = v,

                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectCoverPlaylist(BuildContext context, PlaylistViewModel vm) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Take a picture"),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image != null) {
                      final file = File(image.path);
                      final dir = vm.docsDir;
                      await file.copy(join(dir.path, "playlist_cover"));
                      vm.triggerRebuild();
                    }
                    Navigator.of(ctx).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                GestureDetector(
                  child: Text("Select From Gallery"),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      final file = File(image.path);
                      final dir = vm.docsDir;
                      await file.copy(join(dir.path, "playlist_cover"));
                      vm.triggerRebuild();
                    }
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save(BuildContext context, PlaylistViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await vm.savePlaylist();

    _nameController.clear();
    _descController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Playlist criada"),
      ),
    );
  }
}