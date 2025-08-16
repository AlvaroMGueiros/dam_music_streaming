import 'package:dam_music_streaming/ui/core/themes/light.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import 'dart:io';
import 'ui/playlists/widgets/playlists_view.dart';
import 'ui/login/login_inicio.dart';
import 'ui/login/cadastro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await startMeUp();
  runApp(HarmonyApp(docsDir: docsDir));
}

Future<Directory> startMeUp() async {
  return await getApplicationDocumentsDirectory();
}

class HarmonyApp extends StatelessWidget {
  final Directory _docsDir;
  const HarmonyApp({super.key, required Directory docsDir}) : _docsDir = docsDir;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginInicio(docsDir: _docsDir),
      routes: {
        '/home': (_) => HomeScaffold(docsDir: _docsDir),
        '/signup': (_) => CadastroPage(docsDir: _docsDir),
      },
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final Directory docsDir;
  const HomeScaffold({super.key, required this.docsDir});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SvgIcon(assetName: 'assets/icons/Logo.svg', size: 40),
                SizedBox(width: 4),
                Text("Harmony"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text("Home")),
            const Center(child: Text("Search")),
            const Center(child: Text("Tocando")),
            Playlist(docsDir: docsDir),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Home.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Search.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Song.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Library.svg', size: 35)),
          ],
        ),
      ),
    );
  }
}
