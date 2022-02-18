import 'package:eyebody/eyebody_class.dart';
import 'package:eyebody/utils.dart';
import 'package:eyebody/view/food.dart';
import 'package:eyebody/style.dart';
import 'package:eyebody/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eyebody/database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'body.dart';

class Eyebody extends StatefulWidget {
  Eyebody({Key key}) : super(key: key);

  @override
  _EyebodyState createState() => _EyebodyState();
}

class _EyebodyState extends State<Eyebody> {
  final dbHelper = DatabaseHelper.instance;
  int currentIndex = 0;
  int chartIndex = 0;

  CalendarController calendarController = CalendarController();

  TextEditingController wtController = TextEditingController();
  TextEditingController mtController = TextEditingController();
  TextEditingController ftController = TextEditingController();

  List<WorkOut> workouts = [];
  List<Food> foods = [];
  List<Food> allFoods = [];
  List<EyeBody> bodies = [];
  List<Weight> weight = [];
  List<Weight> weights = []; //차트용
  List<WorkOut> allWorkouts = [];
  DateTime dateTime = DateTime.now();

  void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    workouts = await dbHelper.queryWorkoutByDate(_d);
    bodies = await dbHelper.queryEyeBodyByDate(_d);
    weight = await dbHelper.queryWeightByDate(_d);
    weights = await dbHelper.queryAllWeight(); // 차트용
    allWorkouts = await dbHelper.queryAllWorkout(); // 차트용
    allFoods = await dbHelper.queryAllFood();

    if (weight.isNotEmpty) {
      final w = weight.first;
      wtController.text = w.weight.toString();
      mtController.text = w.muscle.toString();
      ftController.text = w.fat.toString();
    } else {
      wtController.text = "";
      mtController.text = "";
      ftController.text = "";
    }

    setState(() {});
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: getPage(),
      floatingActionButton: [1, 2].contains(currentIndex)
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: bgColor,
                    context: context,
                    builder: (ctx) {
                      return SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                            TextButton(
                                onPressed: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => FoodAddPage(
                                                food: Food(
                                                  date: Utils.getFormatTime(
                                                      dateTime),
                                                  kcal: 0,
                                                  memo: "",
                                                  type: 0,
                                                  meal: 0,
                                                  image: "",
                                                  time: 1130,
                                                ),
                                              )));
                                  getHistories();
                                },
                                child: Text("식단")),
                            TextButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => WorkOutPage(
                                        workout: WorkOut(
                                            date: Utils.getFormatTime(dateTime),
                                            part: 0,
                                            memo: "",
                                            name: "",
                                            type: 0,
                                            time: 60,
                                            kcal: 0,
                                            intense: 0,
                                            distance: 0),
                                      ),
                                    ),
                                  );
                                  getHistories();
                                },
                                child: Text("운동")),
                            TextButton(onPressed: () {}, child: Text("몸무게")),
                            TextButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EyeBodyAddPage(
                                        body: EyeBody(
                                          date: Utils.getFormatTime(dateTime),
                                          image: "",
                                          memo: "",
                                        ),
                                      ),
                                    ),
                                  );
                                  getHistories();
                                },
                                child: Text("눈바디")),
                          ],
                        ),
                      );
                    });
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "오늘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "몸무게"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "통계"),
        ],
        currentIndex: currentIndex,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getHomeWidget();
    } else if (currentIndex == 1) {
      return getHistoryWidget();
    } else if (currentIndex == 2) {
      return getWeightWidget();
    }else if(currentIndex == 3){
      return getStatisticWidger();
    }
    return Container();
  }

  Widget getHomeWidget() {
    return Container(
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: foods.isEmpty
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      child: Image.asset('assets/food.png'),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return Container(
                        width: cardSize,
                        height: cardSize,
                        child: MainFoodCard(
                          foods: foods[idx],
                        ),
                      );
                    },
                    itemCount: foods.length,
                    scrollDirection: Axis.horizontal,
                  ),
            height: cardSize + 20,
          ),
          Container(
            height: cardSize,
            child: workouts.isEmpty
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      child: Image.asset('assets/workout.png'),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, idx) {
                      if (idx == 0) {
                        //몸무게
                        if (weight.isEmpty) {
                          return Container();
                        } else {}
                      }
                      return Container(
                        width: cardSize,
                        height: cardSize,
                        child: MainWorkoutCard(
                          workout: workouts[idx],
                        ),
                      );
                    },
                    itemCount: workouts.length,
                    scrollDirection: Axis.horizontal,
                  ),
          ),
          Container(
            height: cardSize,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                if (idx == 0) {
                  if (weight.isEmpty) {
                    return Container();
                  } else {
                    final w = weight.first;
                    return Container(
                      height: cardSize,
                      width: cardSize,
                      child: Container(
                        height: cardSize,
                        width: cardSize,
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 3,
                                blurRadius: 4,
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${w.weight}kg",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  //몸무게
                } else {
                  if (bodies.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        child: Image.asset('assets/body.png'),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                    //눈바디
                  }
                  return Container(
                    width: cardSize,
                    height: cardSize,
                    child: MainEyeBodyCard(
                      eyeBody: bodies[0],
                    ),
                  );
                }
                return Container(
                  width: cardSize,
                  height: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  Widget getHistoryWidget() {
    return Container(
      height: 600,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {

            DateTime date;
            Map<DateTime, List<dynamic>> events = {};
            for(final food in allFoods){
              date = Utils.numToDateTime2(food.date);
              events[date] = [food];
            }

            return Container(
              child: TableCalendar(
                events: events,
                builders: CalendarBuilders(
                    markersBuilder: (context, date, events, holiday) {
                  if (events.isNotEmpty) {
                    return [
                      Container(
                        width: 10,
                        height: 10,
                        color: Colors.blue,
                      )
                    ];
                  }
                  return [
                    Container(
                      width: 10,
                      height: 10,
                      color: Colors.redAccent,
                    )
                  ];
                }),
                onDaySelected: (date, events, holidays) {
                  dateTime = date;
                  getHistories();
                },
                initialCalendarFormat: CalendarFormat.month,
                availableCalendarFormats: {CalendarFormat.month: ""},
                headerStyle: HeaderStyle(centerHeaderTitle: true),
                initialSelectedDay: dateTime,
                calendarController: calendarController,
              ),
            );
          } else if (idx == 1) {
            return getHomeWidget();
          }
          return Container();
        },
      ),
    );
  }

  CalendarController weightCalendarController = CalendarController();

  Widget getWeightWidget() {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: TableCalendar(
                initialSelectedDay: dateTime,
                initialCalendarFormat: CalendarFormat.week,
                calendarController: weightCalendarController,
                availableCalendarFormats: {CalendarFormat.week: ""},
                onDaySelected: (date, events, holidays) {
                  dateTime = date;
                  getHistories();
                },
                headerStyle: HeaderStyle(centerHeaderTitle: true),
              ),
            );
          } else if (idx == 1) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dateTime.month}월 ${dateTime.day}일"),
                      InkWell(
                        onTap: () async {
                          Weight w;
                          //몸무게가 입력이 안되었을경우
                          if (weight.isEmpty) {
                            w = Weight(date: Utils.getFormatTime(dateTime));
                          } else {
                            w = weight.first;
                          }
                          w.weight = int.tryParse(wtController.text) ?? 0;
                          w.muscle = int.tryParse(wtController.text) ?? 0;
                          w.fat = int.tryParse(wtController.text) ?? 0;
                          print(w.weight);
                          await dbHelper.insertWeight(w);
                          getHistories();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text("저장")),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("몸무게"),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: wtController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("근육량"),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: mtController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("지방"),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: ftController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: txtColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          } else if (idx == 2) {

            List<FlSpot> spots = [];
            for (final w in weights) {
              if (chartIndex == 0) {
                //몸무게
                spots.add(FlSpot(w.date.toDouble(), w.weight.toDouble()));
              } else if (chartIndex == 1) {
                //근육량
                spots.add(FlSpot(w.date.toDouble(), w.muscle.toDouble()));
              } else {
                //지방
                spots.add(FlSpot(w.date.toDouble(), w.fat.toDouble()));
              }
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 0;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: chartIndex == 0 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              "몸무게",
                              style: TextStyle(
                                  color: chartIndex == 0
                                      ? Colors.white
                                      : iTxtColor),
                            )),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 1;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: chartIndex == 1 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              "근육량",
                              style: TextStyle(
                                  color: chartIndex == 1
                                      ? Colors.white
                                      : iTxtColor),
                            )),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 2;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: chartIndex == 2 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              "지방",
                              style: TextStyle(
                                  color: chartIndex == 2
                                      ? Colors.white
                                      : iTxtColor),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                    decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 4,
                              color: Colors.black12)
                        ]),
                    height: 200,
                    child: LineChart(
                        LineChartData(
                        lineBarsData: [
                          //각 항목에 대한 데이터가 들어가는 곳
                          LineChartBarData(spots: spots, colors: [mainColor])],
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(touchTooltipData:
                            LineTouchTooltipData(getTooltipItems: (spots) {
                          return [
                            LineTooltipItem("${spots.first.y}kg",
                                TextStyle(color: mainColor))
                          ];
                        })),
                        titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                showTitles: true,
                                //하단 아래에 날짜표시
                                getTitles: (value) {
                                  DateTime date = Utils.stringToDateTime(value.toInt().toString());
                                  return "${date.day}일";
                                }),
                            leftTitles: SideTitles(showTitles: false)))),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget getStatisticWidger() {
    return Container(
      child: ListView.builder(
          itemCount: 4,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              List<FlSpot> spots = [];
              for (final w in allWorkouts) {
                if (chartIndex == 0) {
                  //몸무게
                  spots.add(FlSpot(w.date.toDouble(), w.time.toDouble()));
                } else if (chartIndex == 1) {
                  //근육량
                  spots.add(FlSpot(w.date.toDouble(), w.kcal.toDouble()));
                } else {
                  //지방
                  spots.add(FlSpot(w.date.toDouble(), w.distance.toDouble()));
                }
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              chartIndex = 0;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: chartIndex == 0 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "운동시간",
                                style: TextStyle(
                                    color: chartIndex == 0
                                        ? Colors.white
                                        : iTxtColor),
                              )),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              chartIndex = 1;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: chartIndex == 1 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "칼로리",
                                style: TextStyle(
                                    color: chartIndex == 1
                                        ? Colors.white
                                        : iTxtColor),
                              )),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              chartIndex = 2;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: chartIndex == 2 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "거리",
                                style: TextStyle(
                                    color: chartIndex == 2
                                        ? Colors.white
                                        : iTxtColor),
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                      decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 4,
                                color: Colors.black12)
                          ]),
                      height: 200,
                      child: spots.isEmpty?Container():LineChart(
                          LineChartData(
                          lineBarsData: [
                            //각 항목에 대한 데이터가 들어가는 곳
                            LineChartBarData(spots: spots, colors: [mainColor])
                          ],
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(touchTooltipData:
                          LineTouchTooltipData(getTooltipItems: (spots) {
                            return [
                              LineTooltipItem("${spots.first.y}",
                                  TextStyle(color: mainColor))
                            ];
                          })),
                          titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                  showTitles: true,
                                  //하단 아래에 날짜표시
                                  getTitles: (value) {
                                   // switch (value.toInt()) {
                                   //   case 2:
                                   //     return '${date.day}';
                                   //   case 5:
                                   //     return 'JUN';
                                   //   case 8:
                                   //     return 'SEP';
                                   // }
                                   // return '';
                                    DateTime date = Utils.stringToDateTime(value.toInt().toString());
                                    return "${date.day}일";
                                  }),
                              leftTitles: SideTitles(showTitles: false)))),
                    )
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }
}
