import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnit/services/file_upload_service.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class PronounciationScreen extends StatefulWidget {
  @override
  _PronounciationScreenState createState() => _PronounciationScreenState();
}

class _PronounciationScreenState extends State<PronounciationScreen> {
  String statusText = "";
  bool isComplete = false;
  bool isMicOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pronounciation Screen'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              statusText,
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              uploadFile();
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              alignment: AlignmentDirectional.center,
              width: 200,
              height: 50,
              child: isComplete && recordFilePath != null
                  ? Text(
                      "Upload To Firebase",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )
                  : Container(),
            ),
          ),
          Text("Chandan", style: GoogleFonts.poppins(fontSize: 40),),
          FloatingActionButton(
            onPressed: () {
              !isMicOn ? startRecord() : stopRecord();
            },
            backgroundColor: isMicOn ? Colors.green : Colors.red ,
            child: isMicOn ? Icon(Icons.mic) : Icon(Icons.mic_off),
          )
        ]),
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      setState(() {
        isMicOn = true;
      });
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isMicOn = false;
      });
      statusText = "Record complete";
      isComplete = true;
      setState(() {});
    }
  }

  late String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      //AudioPlayer audioPlayer = AudioPlayer();
      //audioPlayer.play(recordFilePath!);
    }
  }

  void uploadFile() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      FileUploadService.uploadAudioFile(File(recordFilePath));
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }
}
