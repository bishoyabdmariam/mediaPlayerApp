import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediaplayerapp/consts/colors.dart';
import 'package:mediaplayerapp/consts/textStyle.dart';
import 'package:mediaplayerapp/controller/playerController.dart';
import 'package:mediaplayerapp/views/player.dart';
import 'package:mediaplayerapp/views/search.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SongSearchDelegate(controller),
              );
            },
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: (){
            controller.playIndex((controller.songList.length -controller.playIndex.value)-1);
            controller.toggleSort();
            setState(() {
            });

          },
          icon: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
        ),
        title: Text(
          "Beats",
          style: myStyle(
            family: "bold",
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.checkPermission(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "SomeThing went Wrong",
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Obx(
                    () => ListTile(
                      tileColor: bgDarkColor,
                      title: Text(
                        snapshot.data![index].displayNameWOExt,
                        style: myStyle(
                          family: "bold",
                          size: 15,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data![index].artist != null
                            ? snapshot.data![index].artist!
                            : "Unknown",
                        style: myStyle(
                          family: "regular",
                          size: 12,
                        ),
                      ),
                      leading: QueryArtworkWidget(
                        id: snapshot.data![index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: whiteColor,
                          size: 32,
                        ),
                      ),
                      trailing: IconButton(
                        icon: controller.playIndex.value == index &&
                            controller.isPlay.value == true
                            ? const Icon(
                          Icons.pause,
                          color: whiteColor,
                          size: 26,
                        )
                            : const Icon(
                          Icons.play_arrow,
                          color: whiteColor,
                          size: 26,
                        ),
                        onPressed: () {
                          if(controller.playIndex.value == index) {
                            controller.togglePlayPause();
                          }else{
                            controller.playSong(snapshot.data![index].uri, index);
                          }
                        },

                      ),

                      onTap: () {
                        // Check if the onTap event is coming from the IconButton
                        if (!controller.isPlay.value ) {
                          // If not, navigate to the Player screen
                          Get.to(
                                () => Player(
                              song: snapshot.data!,
                              index: index,
                            ),
                            transition: Transition.downToUp,
                          );
                          controller.playSong(snapshot.data![index].uri, index);

                        } else {
                          // If it's coming from the IconButton, handle play/pause logic
                          if (controller.playIndex.value == index) {
                            // Toggle play/pause when the user taps on the ListTile
                            controller.togglePlayPause();
                          } else {
                            // Play the selected song when tapping a different ListTile
                            controller.playIndex.value = index;
                            Get.to(
                              transition: Transition.downToUp,
                                ()=> Player(song: snapshot.data!, index: index,),
                            );
                            controller.playSong(snapshot.data![index].uri, index);
                          }
                        }
                      },

                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
