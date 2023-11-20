import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediaplayerapp/consts/colors.dart';
import 'package:mediaplayerapp/consts/textStyle.dart';
import 'package:mediaplayerapp/controller/playerController.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPlay = false;
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
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
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
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
                  margin: EdgeInsets.only(bottom: 4),
                  child: Obx(
                    () => ListTile(
                      tileColor: bgColor,
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
                      trailing: controller.playIndex.value == index &&
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
                      onTap: () {
                        controller.playSong(snapshot.data![index].uri, index);
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
