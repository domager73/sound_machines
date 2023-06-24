class TrackTimeData {
  Duration duration;
  Duration position;

  TrackTimeData({required this.duration, required this.position});

  void setPosition(Duration newPosition){
    position = newPosition;
  }

  void setDuration(Duration newDuration){
    duration = newDuration;
  }
}