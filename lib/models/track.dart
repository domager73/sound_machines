class Track {
  String name;
  String imageUrl;
  String audioUrl;
  bool isPlay;
  int id;

  Track(
      {required this.name,
      required this.audioUrl,
      required this.imageUrl,
      required this.isPlay,
      required this.id});

  void setIsPlay(bool _isPLay){
    isPlay = _isPLay;
  }
}
