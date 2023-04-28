import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class VoiceService{
  
  static Future<double> getSimilarityScore(String audioFileUrl, String word) async {

    var headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };

    var url = Uri.parse("http://10.0.2.2:5000/convert");
    var data = {
    "firebase-link":audioFileUrl,
      "word":word
  };
    var res = await http.post(url, body: data, headers: headers);
    var result = jsonDecode(res.body);
    print(result["score"]);
    return double.parse(result["score"]);
  }
  
}