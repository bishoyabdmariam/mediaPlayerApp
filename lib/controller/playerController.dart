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

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
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

  checkPermission() async {
    var perm = await Permission.audio.request();
    if (perm.isGranted) {
      // Fetch the list of songs
      var songs = await audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
      );
      songList = songs;

      // Play the first song
    } else {
      checkPermission();
    }
  }
}
