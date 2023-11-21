import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediaplayerapp/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/playerController.dart';

class SongSearchDelegate extends SearchDelegate<List<SongModel>> {
  final PlayerController controller;

  SongSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, []);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<SongModel> results = controller.songList
        .where((song) =>
    song.displayNameWOExt.toLowerCase().contains(query.toLowerCase()) ||
        (song.artist != null &&
            song.artist!.toLowerCase().contains(query.toLowerCase())))
        .toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SongModel> suggestions = controller.songList
        .where((song) =>
    song.displayNameWOExt.toLowerCase().contains(query.toLowerCase()) ||
        (song.artist != null &&
            song.artist!.toLowerCase().contains(query.toLowerCase())))
        .toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<SongModel> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final SongModel song = results[index];
        return ListTile(
          title: Text(song.displayNameWOExt),
          subtitle: Text(song.artist ?? 'Unknown'),
          onTap: () {

            Get.to(
                  () => Player(
                song: results,
                index: index,
              ),
              transition: Transition.downToUp,
            );
            controller.playSong(results[index].uri, index);
          },
        );
      },
    );
  }
}
