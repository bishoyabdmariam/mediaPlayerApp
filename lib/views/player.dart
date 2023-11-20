import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediaplayerapp/consts/colors.dart';
import 'package:mediaplayerapp/consts/textStyle.dart';
import 'package:mediaplayerapp/controller/playerController.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatefulWidget {
  final SongModel song;

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
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
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
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: QueryArtworkWidget(
                  id: widget.song.id,
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
                child: Column(
                  children: [
                    Text(
                      widget.song.displayNameWOExt,
                      style: myStyle(
                        color: bgDarkColor,
                        family: "bold",
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.song.artist == null ? "UnKnown" : widget.song.artist!,
                      style: myStyle(
                        color: bgDarkColor,
                        family: "regular",
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      ()=> Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: myStyle(
                              color: bgDarkColor,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              min: const Duration(seconds: 0).inSeconds.toDouble(),
                              max: controller.max.value,
                              thumbColor: sliderColor,
                              inactiveColor: bgDarkColor,
                              value: controller.value.value,
                              onChanged: (newValue) {
                                controller.changeDurationToSeconds(newValue.toInt());
                                newValue = newValue;
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
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                        Obx(
                            ()=> CircleAvatar(
                              backgroundColor: bgDarkColor,
                              radius: 35,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  onPressed: () {
                                    if(controller.isPlay.value)
                                    {
                                      controller.audioPlayer.pause();
                                      controller.isPlay(false);
                                    }
                                        else {
                                      controller.audioPlayer.play();
                                      controller.isPlay(true);

                                    }
                                  },
                                  icon: controller.isPlay.value
                                      ? Icon(
                                          Icons.pause_rounded,
                                          color: whiteColor,
                                        )
                                      : Icon(
                                          Icons.play_arrow_rounded,
                                          color: whiteColor,
                                        ),
                                ),
                              )),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
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
          ],
        ),
      ),
    );
  }
}
