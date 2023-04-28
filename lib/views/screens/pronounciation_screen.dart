import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnit/services/file_upload_service.dart';
import 'package:learnit/services/voice_service.dart';
import 'package:learnit/utils/data.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
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
  double similarityScore = -1;
  bool isLoading = false;
  FlutterTts flutterTts = FlutterTts();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size(double.infinity, MediaQuery.of(context).size.height * 0.08),
          child: Center(
            child: Column(
              children: [
                SafeArea(
                  child: Text(
                    "Learn IT",
                    style: GoogleFonts.podkova(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 38),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(children: [
              Divider(
                color: Colors.red,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: neumorphicDecoration(15),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      pQuestionsList[i][0],
                      style: GoogleFonts.poppins(fontSize: 70),
                    ),
                    Text(
                      "English: " + pQuestionsList[i][1],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      print("Hi");
                      await flutterTts.setLanguage("pt");
                      var res = await flutterTts.speak(pQuestionsList[i][0]);
                      print("Hiiii");
                      },
                    child: Icon(Icons.volume_up),
                  ),
                  SizedBox(width: 18,),
                  FloatingActionButton(
                    onPressed: () {
                      !isMicOn ? startRecord() : stopRecord();
                    },
                    backgroundColor: isMicOn ? Colors.green : Colors.red,
                    child: isMicOn ? Icon(Icons.mic) : Icon(Icons.mic_off),
                  ),
                ],
              ),
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
                  width: 250,
                  height: 50,
                  child: isComplete && recordFilePath != null
                      ? Container(
                          alignment: AlignmentDirectional.center,
                          width: 250,
                          height: 50,
                          decoration: neumorphicDecoration(15),
                          child: Text(
                            "Check Similarity Score",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                    isComplete && recordFilePath != null && similarityScore != -1
                        ? Center(
                            child: FAProgressBar(
                            currentValue: similarityScore.toDouble(),
                            displayText: '%',
                            backgroundColor: Colors.white70,
                            progressColor: similarityScore.toDouble()>60.0 ? Colors.green : Colors.red,
                          ))
                        : Container(),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    i++;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  alignment: AlignmentDirectional.center,
                  width: 250,
                  height: 50,
                  child: isComplete && recordFilePath != null
                      ? Container(
                          alignment: AlignmentDirectional.center,
                          width: 250,
                          height: 50,
                          decoration: neumorphicDecoration(15),
                          child: Text(
                            "Get Next Question",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        )
                      : Container(),
                ),
              ),
            ]),
            if (isLoading)
              Container(
                  color: Colors.white54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
          ],
        ),
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
        similarityScore = -1;
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

  void uploadFile() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      setState(() {
        isLoading = true;
      });
      try{
        String link =
        await FileUploadService.uploadAudioFile(File(recordFilePath));
        similarityScore =
        await VoiceService.getSimilarityScore(link, pQuestionsList[i][0]);
        if (similarityScore < 10){
          setState(() {
            statusText = "Try Again";
          });
        }
      }
      finally {
        setState(() {
          isLoading = false;
        });
      }
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
    return sdPath + "/test_${i}.mp3";
  }
}
