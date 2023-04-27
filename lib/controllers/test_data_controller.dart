import 'package:get/get.dart';
import 'package:learnit/models/test_data.dart';

class TestHistoryController extends GetxController{
  RxList<TestHistoryItem> tests=<TestHistoryItem>[
    TestHistoryItem(number: "1", score: 15, totalScore: 20, date: DateTime.now())
  ].obs;

  void addTest(){

  }
}