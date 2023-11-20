import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{

final audioQuery = OnAudioQuery();
final audioPlayer = AudioPlayer();

RxInt playIndex =0.obs ;
var isPlay = false.obs;

var max = 0.0.obs;
var value = 0.0.obs;

var duration = ''.obs;
var position = ''.obs;

@override
  void onInit() {
    checkPermission();
    super.onInit();
  }


  updatePosition(){
    audioPlayer.durationStream.listen((durationEvent) {
      duration.value = durationEvent.toString().split(".")[0];
      max.value = durationEvent!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((positionEvent) {
      position.value = positionEvent.toString().split(".")[0];
      value.value = positionEvent.inSeconds.toDouble();

    });
  }


  changeDurationToSeconds(seconds){
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }


  playSong(String? uri , int index){
  playIndex.value = index;
    try{
      audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!))
      );
      audioPlayer.play();
      isPlay(true);
      updatePosition();
    } on Exception catch (e){
      print(e.toString());
    }
  }
/*
pauseSong(String? uri ){
  try{
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!))
    );
    audioPlayer.pause();
  } on Exception catch (e){
    print(e.toString());
  }
}*/


  checkPermission()async{
    var perm = await Permission.audio.request();
    if(perm.isGranted){
    }else{
      checkPermission();
    }
  }

}
