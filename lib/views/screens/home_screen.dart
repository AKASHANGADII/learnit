import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnit/controllers/test_data_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  TestHistoryController testDataController=Get.put(TestHistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LearnIt"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: testDataController.tests.length,
            itemBuilder: (context, index) => Container(),
          ),
        ],
      ),
    );
  }
}
