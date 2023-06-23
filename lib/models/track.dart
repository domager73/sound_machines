class Track {
  String name;
  String imageUrl;
  String audioUrl;
  bool isPlay;
  int id;
  String firebaseId;

  Track(
      {required this.name,
      required this.audioUrl,
      required this.imageUrl,
      required this.isPlay,
      required this.id,
      required this.firebaseId});
}
