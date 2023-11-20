import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{

final audioQuery = OnAudioQuery();
final audioPlayer = AudioPlayer();

RxInt playIndex =0.obs ;
var isPlay = false.obs;

@override
  void onInit() {
    checkPermission();
    super.onInit();
  }

  playSong(String? uri , int index){
  playIndex.value = index;
    try{
      audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!))
      );
      audioPlayer.play();
      isPlay(true);
    } on Exception catch (e){
      print(e.toString());
    }
  }

pauseSong(String? uri ){
  try{
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!))
    );
    audioPlayer.pause();
  } on Exception catch (e){
    print(e.toString());
  }
}


  checkPermission()async{
    var perm = await Permission.audio.request();
    if(perm.isGranted){
    }else{
      checkPermission();
    }
  }

}
