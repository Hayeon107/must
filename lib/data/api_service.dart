import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:must/data/quizJson.dart';
import 'package:must/data/searchJson.dart';
import 'package:must/data/soundQuizParsing.dart';
import 'dart:convert';
import 'json2.dart';

Uint8List decodeBase64(String base64String) {
  return base64.decode(base64String);
}

Future enrollSongData(String query) async {
  var url = Uri.parse('http://222.108.102.12:9090/songs/${query}');
  String _data = 'No data';
  try {
    var response = await http.post(url);
    // Log headers and status code for debugging
    print('Response status: ${response.statusCode}');
    print('Headers: ${response.headers}');

    // Check for content type and process accordingly
    if (response.headers['content-type']?.contains('application/json') ??
        false) {
      var jsonData = json.decode(response.body);
      _data = jsonData.toString();
      print('JSON data: $_data');
    } else {
      // If not JSON, just decode as text for now
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Non-JSON Response body: $decodedBody');
      _data = decodedBody;
    }
  } catch (e) {
    print('Exception caught: $e');
    _data = 'Failed to make request: $e';
    print(_data);
  }
}

Future<Uint8List?> fetchSongThumbnail(int songID) async {
  Uint8List? imageBytes;
  var url = Uri.parse('http://222.108.102.12:9090/image/${songID}');
  try {
    var response2 = await http.get(url);
    if (response2.statusCode == 200 &&
        response2.headers['content-type']!.startsWith('image/') ?? false) {
      print('Image response status: ${response2.statusCode}');
      imageBytes = response2.bodyBytes;
      return imageBytes;
    } else {
      'Failed to load image: Server responded ${response2.statusCode}';
      imageBytes = null;
      return imageBytes;
    }
  } catch (e) {
    print('Failed to make request for image: $e');
  }
}

Future<List<SearchSong>> fetchSongData() async {
  var url = Uri.parse('http://222.108.102.12:9090/main/songs/1?pageNum=0');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      List<SearchSong> song = searchSongsFromJson(decodedBody);
      return song;// Return the list of songs directly
    } else {
      throw Exception('Failed to load song data');
    }
  } catch (e) {
    print('Failed to make request: $e');
    return []; // Return an empty list in case of failure
  }
}

Future<void> fetchSongsAndThumbnails(List<Song> songs) async {
  Map<int, Uint8List> thumbnails = {}; // 여기서 썸네일 저장할 맵을 선언
  try {
    for (var song in songs) {
      if (song.songId != null) { // 노래 데이터가 있고, songId가 있으면 썸네일 가져옴
        Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
        if (thumbnail != null) {
          thumbnails[song.songId] = thumbnail;
          print('Thumbnail for song ID ${song.songId} fetched');
        }
      } else {
        print('no song id!');
      }
    }
  } catch (e) {
    print('Error fetching thumbnails: $e');
  }
}

Future<List<SearchSong>> searchSongData(String? query) async {
  var url = Uri.parse('http://222.108.102.12:9090/1/search?artist=$query');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      // SearchSong searchSong = searchSongFromJson(decodedBody);
      List<SearchSong> song = searchSongsFromJson(decodedBody);
      return song;
    } else {
      print('One or both responses failed');
      throw Exception('Failed to load song data due to server response: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to make request: $e');
    throw Exception('Failed to process request: $e'); // Ensure you throw an exception here
  }
}

Future<MeanQuiz> fetchMeanQuizData() async {
  var url = Uri.parse('');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return meanQuizFromJson(response.body);  // JSON 문자열을 MeanQuiz 객체로 변환
    } else {
      throw Exception('Failed to load song data');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<List<MeanQuiz>> notAPIMeanQuizData() async {
  try {
    // assets 폴더에 저장된 quizData.json 파일에서 JSON 문자열 읽기
    String jsonString = await rootBundle.loadString('assets/quizData.json');
    // JSON 문자열을 Dart 객체로 파싱
    return MeanQuiz.parseUserList(jsonString);
  } catch (e) {
    print('Error loading quiz data: $e');
    throw Exception('Failed to load quiz data');
  }
}