import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnit/controllers/test_data_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:learnit/models/test_data.dart';

class HomeScreen extends StatelessWidget {
  static const routeName='/home-screen';
  HomeScreen({Key? key}) : super(key: key);
  TestHistoryController testDataController = Get.put(TestHistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LearnIt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Previous Tests"),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: testDataController.tests.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Test "+testDataController.tests.value[index].number),
                            Text(DateFormat.yMMMd().format(testDataController.tests.value[index].date).toString()),

                          ],
                        ),
                        const SizedBox(width: 35,),
                        CircularPercentIndicator(
                            center: Text("${testDataController.tests.value[index].score}/${testDataController.tests.value[index].totalScore}"),
                            percent: testDataController.tests.value[index].score=="0"?0:testDataController.tests.value[index].score/testDataController.tests.value[index].totalScore,
                            radius: 30,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("New Tests"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewTestOptionButton(
                  label: "Parts of speech",
                  onPressed: (){
                    //TODO:Navigate to test screen
                  },
                ),
                NewTestOptionButton(
                  label: "Pronounciation",
                  onPressed: (){
                    //TODO:Navigate to test screen
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NewTestOptionButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const NewTestOptionButton({super.key, required this.label,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 150,
        width: 150,
        color: Colors.grey,
        child: Center(child: Text(label)),
      ),
    );
  }
}
