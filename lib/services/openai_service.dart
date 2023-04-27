import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:learnit/utils/constants.dart';

class OpenAiService {
  static var headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $openaiApiKey',
  };

  static Future<Map<String,dynamic>> getWordCategories(String sentence) async {
    Future.delayed(Duration(seconds: 3));
    var data =
        '{"model": "gpt-3.5-turbo","messages": [{"role": "user", "content": "This is the sentence within the brackets - (' + sentence + ') These are the parts of speech categories - Adjective, Adverb, Conjunction, Determiner, Noun, Number, Preposition, Pronoun, Verb. I have to categorise the words into categories based on parts of speech. Please give a json like map with key as individual words and value as the category that word belongs to. Only give the map, please do not add any extra text."}]}';

    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    } else {
      var responseJson = jsonDecode(res.body);
      String wordCategoriesStr =
          responseJson["choices"][0]["message"]["content"];
      log(json.decode(wordCategoriesStr).toString());
      return json.decode(wordCategoriesStr);
    }
  }
}
