
class Food {
  int id;
  int date;
  int type;
  int kcal;
  int meal;
  int time;
  String memo;
  String image;

  Food(
      {this.id,
      this.date,
      this.type,
      this.kcal,
        this.meal,
      this.time,
      this.memo,
      this.image});

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      id: data["id"],
      date: data["date"],
      type: data["type"],
      kcal: data["kcal"],
      meal: data["meal"],
      time: data["time"],
      memo: data["memo"],
      image: data["image"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "date": this.date,
      "type": this.type,
      "kcal": this.kcal,
      "meal": this.meal,
      "time": this.time,
      "memo": this.memo,
      "image": this.image,
    };
  }
}

class WorkOut {
  int id;
  int date;
  int time;
  int kcal;
  int intense;
  int part;
  int type;
  int distance;

  String name;
  String memo;

  WorkOut(
      {this.id,
      this.date,
      this.time,
      this.intense,
        this.distance,
        this.type,
        this.kcal,
      this.part,
      this.name,
      this.memo});

  factory WorkOut.fromDB(Map<String, dynamic> data) {
    return WorkOut(
      id: data["id"],
      date: data["date"],
      time: data["time"],
      type: data["type"],
      kcal: data["kcal"],
      distance: data["distance"],
      intense: data["intense"],
      part: data["part"],
      name: data["name"].toString(),
      memo: data["memo"].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "date": this.date,
      "time": this.time,
      "type": this.type,
      "kcal": this.kcal,
      "distance": this.distance,
      "intense": this.intense,
      "part": this.part,
      "name": this.name,
      "memo": this.memo,
    };
  }
}

class EyeBody {
  int id;
  int date;
  String image;
  String memo;

  EyeBody({this.id, this.date, this.image, this.memo});

  factory EyeBody.fromDB(Map<String, dynamic> data) {
    return EyeBody(
      id: data["id"],
      date: data["date"],
      image: data["image"],
      memo: data["memo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "date": this.date,
      "image": this.image,
      "memo": this.memo,
    };
  }
}

class Weight {
  int date;
  int weight;
  int fat;
  int muscle;

  Weight({this.date, this.weight, this.fat, this.muscle});

  factory Weight.fromDB(Map<String, dynamic> data) {
    return Weight(
      date: data["date"],
      weight: data["weight"],
      fat: data["fat"],
      muscle: data["muscle"],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "date" : this.date,
      "weight": this.weight,
      "fat": this.fat,
      "muscle": this.muscle,
    };
  }
}
