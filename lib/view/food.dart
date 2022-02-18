import 'package:eyebody/database.dart';
import 'package:eyebody/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../eyebody_class.dart';
import '../utils.dart';

class FoodAddPage extends StatefulWidget {
  final Food food;

  FoodAddPage({Key key, this.food}) : super(key: key);

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  Food get foods => widget.food;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoController.text = foods.memo;
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
                foods.memo = memoController.text;
                await db.insertFood(foods);
                Navigator.of(context).pop();
              },
              child: Text("저장"))
        ],
        elevation: 1,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (ctx, idx) {
              if (idx == 0) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  width: cardSize,
                  height: cardSize,
                  child: InkWell(
                    child: AspectRatio(
                      child: Align(
                        child: foods.image.isEmpty
                            ? Image.asset("assets/food.png")
                            : AssetThumb(
                                asset: Asset(foods.image, "food.png", 0, 0),
                                width: cardSize.toInt(),
                                height: cardSize.toInt()),
                      ),
                      aspectRatio: 1,
                    ),
                    onTap: () {
                      selectImage();
                    },
                  ),
                );
              } else if (idx == 1) {
                String _t = foods.time.toString();
                String _m = "";
                String _h = "";
                if(_t.length <3){
                  _m =_t;
                  _h ="0";
                }else{
                      _m = _t.substring(_t.length-2);
                      _h = _t.substring(0,_t.length-2);
                }
                TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("식사시간"),
                          InkWell(
                              onTap: () async {
                                TimeOfDay _time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {
                                  foods.time = int.parse(
                                      "${(_time.hour)}${Utils.makeTwoDigit(_time.minute)}");
                                  //시간 구분하기 위해서 시간과 분 따로 구분
                                });
                                if (_time == null) {
                                  return;
                                }
                              },
                              child: Text("${time.hour > 11 ? "오후" : "오전"} "
                                  "${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)} 분")),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(mealTime.length, (_idx) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                foods.meal = _idx;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: foods.meal == _idx
                                      ? mainColor
                                      : ibgColor),
                              alignment: Alignment.center,
                              child: Text(
                                mealTime[_idx],
                                style: TextStyle(
                                    color: foods.meal == _idx
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
              } else if (idx == 2) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("식사평가"),
                          Text("오전 11:32"),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(mealType.length, (_idx) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                foods.type = _idx;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: foods.type == _idx
                                      ? mainColor
                                      : ibgColor),
                              alignment: Alignment.center,
                              child: Text(
                                mealType[_idx],
                                style: TextStyle(
                                    color: foods.type == _idx
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

  Future<void> selectImage() async {
    final _img =
        await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);
    if (_img.length < 1) {
      return;
    }
    setState(() {
      foods.image = _img.first.identifier;
    });
  }
}

class MainFoodCard extends StatelessWidget {
  final Food foods;

  MainFoodCard({Key key, this.foods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _t = foods.time.toString();
    String _m = "";
    String _h = "";
    if(_t.length <3){
      _m =_t;
      _h ="0";
    }else{
      _m = _t.substring(_t.length-2);
      _h = _t.substring(0,_t.length-2);
    }
    TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
    return Container(
      margin: EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AssetThumb(
                    asset: Asset(foods.image, "food.png", 0, 0),
                    width: cardSize.toInt(),
                    height: cardSize.toInt()),
              ),
            ),
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20)),
            )),
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "${time.hour > 11 ? "오후" : "오전"} "
                  "${Utils.makeTwoDigit(time.hour % 12)}"
                  ":${Utils.makeTwoDigit(time.minute)} 분",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    mealTime[foods.meal],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  decoration: BoxDecoration(
                      color: mainColor, borderRadius: BorderRadius.circular(8)),
                ))
          ],
        ),
      ),
    );
  }
}
