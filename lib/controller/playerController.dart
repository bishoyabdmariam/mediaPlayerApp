import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  RxInt playIndex = 0.obs;
  var isPlay = false.obs;
  var isSongDone = false.obs;
  RxBool isAsc = true.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;

  var duration = ''.obs;
  var position = ''.obs;

  List<SongModel> songList = [];

  @override
  void onInit() {
    checkPermission();
    super.onInit();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((durationEvent) {
      duration.value = durationEvent.toString().split(".")[0];
      max.value = durationEvent!.inSeconds.toDouble();
    });

    audioPlayer.positionStream.listen((positionEvent) {
      position.value = positionEvent.toString().split(".")[0];
      value.value = positionEvent.inSeconds.toDouble();

      // Check if the song has ended
      if (max.value != 0 && value.value >= max.value) {
        isPlay(false);
        isSongDone(true);

        // Play the next song if available
        if (playIndex.value < songList.length - 1) {
          playSong(songList[playIndex.value + 1].uri, playIndex.value + 1);
          playIndex.value++;
        } else {
          // Loop to the beginning if no more songs
          playIndex.value = 0;
          playSong(songList[playIndex.value].uri, playIndex.value);
        }

        isSongDone(false);
        position.value = '';
        value.value = 0;
      }
    });
  }

  changeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);

    audioPlayer.durationStream.first.then((durationEvent) {
      // Check if the specified duration is greater than or equal to the song's duration
      if (duration >= durationEvent!) {
        // Check if there is a next song
        if (playIndex.value < songList.length - 1) {
          // Play the next song
          playSong(songList[playIndex.value + 1].uri, playIndex.value + 1);
          playIndex.value++;
        } else {
          // If no next song, loop to the beginning
          playIndex.value = 0;
          playSong(songList[playIndex.value].uri, playIndex.value);
        }
      } else {
        // Seek to the specified duration within the current song
        audioPlayer.seek(duration);
      }
    });
  }

  playSong(String? uri, int index) {
    isSongDone(false);
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
          tag: MediaItem(
            id: '${songList[index].id}',
            title: songList[index].displayNameWOExt,
            album: '${songList[index].album}',
            artist: '${songList[index].artist}',
            playable: isPlay.value,
          ),
        ),
      );
      audioPlayer.play();
      isPlay(true);
      updatePosition();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  togglePlayPause() {
    if (isPlay.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    isPlay.toggle();
  }

  toggleSort() {
    isAsc.toggle();
  }
  Future<List<SongModel>> checkPermission() async {
    var perm = await Permission.audio.request();

    if (perm.isGranted) {
      // Permission is granted, fetch the list of songs
      List<SongModel> songs = await audioQuery.querySongs(
        ignoreCase: true,
        orderType: isAsc.value ? OrderType.ASC_OR_SMALLER : OrderType.DESC_OR_GREATER,
        sortType: null,
        uriType: UriType.EXTERNAL,
      );
      return songs;
    } else if (perm.isDenied || perm.isRestricted) {
      // Permission is denied or restricted, handle it gracefully
      await showPermissionSnackbar();
      return checkPermission(); // Call the function recursively
    } else if (perm.isPermanentlyDenied) {
      // Permission is permanently denied, prompt the user to open settings
      await showPermissionPermanentlyDeniedDialog();
      return checkPermission();
    } else {
      // Handle other permission statuses (e.g., asking again later)
      return checkPermission();
    }
  }

  Future<void> showPermissionSnackbar() async {

    Get.snackbar(
      'Permission Denied',
      'Please grant access to your device\'s audio to use this feature.',
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () {
          openAppSettings(); // Open app settings so the user can grant the permission manually
        },
        child: const Text(
          'Open Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> showPermissionPermanentlyDeniedDialog() async {
    // You can customize this dialog to provide more information or options to the user
    await Get.defaultDialog(
      title: 'Permission Denied',
      content: const Text('You have permanently denied access to audio. Please grant access in the app settings.'),
      actions: [
        TextButton(
          onPressed: () {
            openAppSettings(); // Open app settings so the user can grant the permission manually
          },
          child: const Text('Open Settings'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

}
