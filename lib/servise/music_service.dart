import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sound_machines/models/playlist.dart';

import '../models/track.dart';


const String defaultUrl = 'https://www.chosic.com/wp-content/uploads/2022/02/storm-clouds-purpple-cat.mp3';

class MusicService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref('tracks/');
  final imagesRef = FirebaseStorage.instance.ref('images/');

  Future addData(String id, Map<String, dynamic> data) async {
    CollectionReference tracks = firestore.collection('musics');
    await tracks.doc(id).set(data, SetOptions(merge: true));
  }

  Future<String> getIdForNewTrack() async {
    CollectionReference tracks = firestore.collection('musics');
    final doc = await tracks.add({'name': 'name'});
    log(doc.path);
    return doc.path.split('/')[1];
  }

  void uploadNewTrack(File? file, File? image, String name) async {
    final id = await getIdForNewTrack();

    final String audioUrl = file != null ? await uploadAudio(file, id) : defaultUrl;
    final String imageUrl = image != null ? await uploadImage(image, id) : '';

    await addData(id, {'audioUrl': audioUrl, 'imageUrl': imageUrl, 'name': name});
  }

  void createManyTracks(int count) {
    for (var i = 0; i < count; i ++) {
      uploadNewTrack(null, null, 'test $i');
    }
  }

  Future<String> uploadAudio(File audio, String id) async {
    final child = storageRef.child('$id.mp3');
    return await child.putFile(audio).then((p0) => child.getDownloadURL());
  }

  Future<String> uploadImage(File image, String id) async {
    final child = imagesRef.child('$id.jpg');
    return await child.putFile(image).then((p0) => child.getDownloadURL());
  }

  // Future<Track> getLastTrack() async {
  //   final collection = await firestore.collection('musics').get();
  //   final trackData = collection.docs.last.data();
  //   return Track(name: trackData['name'], audioUrl: trackData['audioUrl'], imageUrl: trackData['imageUrl'], isPlay: false);
  // }

  Future<List<Track>> getAllTracks() async {
    final collection = await firestore.collection('musics').get();
    List<Track> tracks = [];

    int count = 0;
    for (var i in collection.docs) {
      tracks.add(Track(name: i.data()['name'], audioUrl: i.data()['audioUrl'], imageUrl: i.data()['imageUrl'], isPlay: false, id: count));
      count++;
    }

    return tracks;
  }

  // Future<List<Track>> getPlaylistTracks(String id) async {
  //   final playlist = await firestore.collection('playlists').doc(id).get();
  //   final List tracksIds = playlist.data()!['tracks'];
  //
  //   List<Track> tracks = [];
  //
  //   for (var i in tracksIds) {
  //     final doc = await firestore.collection('musics').doc(i).get();
  //     tracks.add(Track(name: doc.data()!['name'], audioUrl: doc.data()!['audioUrl'], imageUrl: doc.data()!['imageUrl'], isPlay: false),);
  //   }
  //
  //   return tracks;
  // }


  Future<List<Playlist>> loadPlaylists() async {
    final collection = await firestore.collection('playlists').get();
    List<Playlist> playlists = [];

    for (var i in collection.docs) {
      playlists.add(Playlist(name: i.data()['name'], imageUrl: i.data()['imageUrl'], id: i.id));
    }

    return playlists;
  }

}
