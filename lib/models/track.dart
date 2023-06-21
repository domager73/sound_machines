class Track {
  String name;
  String imageUrl;
  String audioUrl;
  bool isPlay;

  Track(
      {required this.name,
      required this.audioUrl,
      required this.imageUrl,
      required this.isPlay});

  void setIsPlay(bool _isPLay){
    isPlay = _isPLay;
  }
}
