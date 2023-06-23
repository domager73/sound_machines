class TrackTimeData {
  Duration duration;
  Duration position;

  TrackTimeData({required this.duration, required this.position});

  TrackTimeData copyWithPosition(Duration newPosition) {
    return TrackTimeData(duration: duration, position: newPosition);
  }

  TrackTimeData copyWithDuration(Duration newDuration) {
    return TrackTimeData(duration: newDuration, position: position);
  }
}