import 'package:eyebody/database.dart';
import 'package:eyebody/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../eyebody_class.dart';
import '../utils.dart';

class WorkOutPage extends StatefulWidget {
  final WorkOut workout;

  WorkOutPage({Key key, this.workout}) : super(key: key);

  @override
  _WorkOutPageState createState() => _WorkOutPageState();
}

class _WorkOutPageState extends State<WorkOutPage> {
  List<String> wIntense = [
    "약하게",
    "적당히",
    "고강도",
  ];
  List<String> wPart = ["팔", "다리", "복근", "등", "어깨"];

  WorkOut get workout => widget.workout;
  TextEditingController memoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoController.text = workout.memo;
    nameController.text = workout.name;
    timeController.text = workout.time.toString();
    calController.text = workout.kcal.toString();
    distanceController.text = workout.distance.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: txtColor),
        actions: [
          TextButton(
              onPressed: () async {
                final db = DatabaseHelper.instance;
                workout.memo = memoController.text;
                workout.name = nameController.text;

                if (timeController.text.isEmpty) {
                  workout.time = 0;
                } else {
                  workout.time = int.parse(timeController.text);
                }
                if (calController.text.isEmpty) {
                  workout.time = 0;
                } else {
                  workout.kcal = int.parse(calController.text);
                }

                if (distanceController.text.isEmpty) {
                  workout.distance = 0;
                } else {
                  workout.distance = int.parse(distanceController.text);
                }

                await db.insertWorkout(workout);
                Navigator.of(context).pop();
              },
              child: Text("저장"))
        ],
        elevation: 1,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (ctx, idx) {
              if (idx == 0) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        child: InkWell(
                          child: Image.asset("assets/${workout.type}.png"),
                          onTap: () {
                            setState(() {
                              workout.type++;
                              workout.type = workout.type % 4;
                            });
                          },
                        ),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: ibgColor,
                            borderRadius: BorderRadius.circular(70)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.5),
                                borderRadius: BorderRadius.circular(8))),
                      ))
                    ],
                  ),
                );
              } else if (idx == 1) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("운동 시간"),
                          Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: timeController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            width: 70,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("운동 칼로리"),
                          Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: calController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            width: 70,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("운동 거리"),
                          Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: distanceController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            width: 70,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else if (idx == 2) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("운동 부위"),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(wPart.length, (_idx) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                workout.part = _idx;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: workout.part == _idx
                                      ? mainColor
                                      : ibgColor),
                              alignment: Alignment.center,
                              child: Text(
                                wPart[_idx],
                                style: TextStyle(
                                    color: workout.part == _idx
                                        ? Colors.white
                                        : iTxtColor),
                              ),
                            ),
                          );
                        }),
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 2.5,
                      )
                    ],
                  ),
                );
              } else if (idx == 3) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("운동 강도"),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(wIntense.length, (_idx) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                workout.intense = _idx;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: workout.intense == _idx
                                      ? mainColor
                                      : ibgColor),
                              alignment: Alignment.center,
                              child: Text(
                                wIntense[_idx],
                                style: TextStyle(
                                    color: workout.intense == _idx
                                        ? Colors.white
                                        : iTxtColor),
                              ),
                            ),
                          );
                        }),
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 2.5,
                      )
                    ],
                  ),
                );
              } else if (idx == 4) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("메모"),
                      SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: memoController,
                        maxLines: 10,
                        minLines: 10,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.5))),
                      )
                    ],
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

class MainWorkoutCard extends StatelessWidget {
  final WorkOut workout;

  MainWorkoutCard({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 4, color: Colors.black12)
          ]),
      child: ClipRRect(
        child: AspectRatio(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Image.asset("assets/${workout.type}.png"),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ibgColor,
                          borderRadius: BorderRadius.circular(70)),
                    ),
                    Expanded(
                        child: Text(
                      "${Utils.makeTwoDigit(workout.time ~/ 60)}:${Utils.makeTwoDigit(workout.time % 60)}",
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: Text(workout.name)),
                Text(workout.kcal == 0 ? "" : "${workout.kcal}kcal"),
                Text(workout.distance == 0 ? "" : "${workout.distance}km"),
              ],
            ),
          ),
          aspectRatio: 1,
        ),
      ),
    );
  }
}
