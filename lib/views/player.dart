import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediaplayerapp/consts/colors.dart';
import 'package:mediaplayerapp/consts/textStyle.dart';
import 'package:mediaplayerapp/controller/playerController.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatefulWidget {
  final List<SongModel> song;

  final int index;

  const Player({
    super.key,
    required this.song,
    required this.index,
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  var controller = Get.find<PlayerController>();
  @override
  void initState() {
    super.initState(); // Initialize the controller with the song list
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          8.0,
        ),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: QueryArtworkWidget(
                    id: widget.song[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 48,
                      color: whiteColor,
                    ),
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: whiteColor,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        widget
                            .song[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: myStyle(
                          color: bgDarkColor,
                          family: "bold",
                          size: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.song[controller.playIndex.value].artist == null
                            ? "UnKnown"
                            : widget.song[controller.playIndex.value].artist!,
                        style: myStyle(
                          color: bgDarkColor,
                          family: "regular",
                          size: 20,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: myStyle(
                                color: bgDarkColor,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                onChangeStart: (d){
                                  controller.togglePlayPause();
                                },
                                onChangeEnd: (d){
                                  controller.togglePlayPause();
                                },
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                thumbColor: sliderColor,
                                inactiveColor: bgDarkColor,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(newValue.toInt());
                                },
                              ),

                            ),
                            Text(
                              controller.duration.value,
                              style: myStyle(
                                color: bgDarkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.playSong(
                                  widget
                                      .song[controller.playIndex.value - 1].uri,
                                  controller.playIndex.value - 1);
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: bgDarkColor,
                            ),
                          ),
                          Obx(
                            () => CircleAvatar(
                                backgroundColor: bgDarkColor,
                                radius: 35,
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      onPressed: () {
                                        if (controller.isPlay.value) {
                                          controller.audioPlayer.pause();
                                          controller.isPlay(false);
                                        } else {
                                          controller.audioPlayer.play();
                                          controller.isPlay(true);
                                            if(controller.value.value >= controller.max.value){

                                              controller.playSong(widget.song[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                                            }

                                        }
                                      },
                                      icon: controller.isPlay.value
                                          ? const Icon(
                                              Icons.pause_rounded,
                                              color: whiteColor,
                                            )
                                          : const Icon(
                                              Icons.play_arrow_rounded,
                                              color: whiteColor,
                                            ),
                                    ),

                                )),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.playSong(
                                  widget
                                      .song[controller.playIndex.value + 1].uri,
                                  controller.playIndex.value + 1);
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: bgDarkColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
