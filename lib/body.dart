import 'package:eyebody/database.dart';
import 'package:eyebody/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../eyebody_class.dart';
import '../utils.dart';

class EyeBodyAddPage extends StatefulWidget {
  final EyeBody body;

  EyeBodyAddPage({Key key, this.body}) : super(key: key);

  @override
  _EyeBodyAddPageState createState() => _EyeBodyAddPageState();
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage> {
  EyeBody get bodys => widget.body;
  TextEditingController memoController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoController.text = bodys.memo;
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
                bodys.memo = memoController.text;
                await db.insertEyeBody(bodys);
                Navigator.of(context).pop();
              },
              child: Text("저장"))
        ],
        elevation: 1,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (ctx, idx) {
              if (idx == 0) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  width: cardSize,
                  height: cardSize,
                  child: InkWell(
                    child: AspectRatio(
                      child: Align(
                        child: bodys.image.isEmpty
                            ? Image.asset("assets/body.png")
                            : AssetThumb(
                            asset: Asset(bodys.image, "body.png", 0, 0),
                            width: cardSize.toInt(),
                            height: cardSize.toInt()),
                      ),
                      aspectRatio: 1 / 1,
                    ),
                    onTap: () {
                      selectImage();
                    },
                  ),
                );
              } else if (idx == 1) {
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
      bodys.image = _img.first.identifier;
    });
  }
}

class MainEyeBodyCard extends StatelessWidget {
  final EyeBody eyeBody;

  MainEyeBodyCard({Key key, this.eyeBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    asset: Asset(eyeBody.image, "food.png", 0, 0),
                    width: cardSize.toInt(),
                    height: cardSize.toInt()),
              ),
            ),
            Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20)),
                )),
          ],
        ),
      ),
    );
  }
}