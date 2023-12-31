
import 'package:sound_machines/models/time_data.dart';
import 'package:sound_machines/models/track.dart';

class TrackData {
  Track data;
  TrackTimeData timeData;
  bool isPlaying;

  TrackData(
      {required this.timeData, required this.data, required this.isPlaying});

  void setTTD(TrackTimeData trackTimeData) {
    timeData = trackTimeData;
  }

  void setPlaying(bool isPlaying){
    isPlaying = isPlaying;
  }

  @override
  String toString() =>
      '------------------------------------\n\nname: ${data.name} \n image: ${data.imageUrl} \n audio: ${data.audioUrl} \n duration: ${timeData.duration.inSeconds} \n position: ${timeData.position.inSeconds}\n\n---------------------';
}