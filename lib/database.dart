import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'eyebody_class.dart';
class DatabaseHelper {

  static final _databaseName = "eyebody.db";
  static final int _databaseVersion = 8;
  static final foodTable = "food";
  static final workoutTable = "workout";
  static final bodyTable = "body";
  static final weightTable = "weight";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

Future<Database>_initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $foodTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      meal INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      image String,
      memo String
    ) 
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $workoutTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      intense INTEGER DEFAULT 0,
      distance INTEGER DEFAULT 0,
      part INTEGER DEFAULT 0,
      name String,
      memo String
    ) 
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $bodyTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      image String,
      memo String
    ) 
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $weightTable(
      date INTEGER DEFAULT 0,
      weight INTEGER DEFAULT 0,
      fat INTEGER DEFAULT 0,
      muscle INTEGER DEFAULT 0 
    ) 
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(newVersion == 8){
      await db.execute(
        """ALTER TABLE $workoutTable
        ADD type INTEGER DEFAULT 0
        """
      );
      await db.execute(
          """ALTER TABLE $workoutTable
        ADD distance INTEGER DEFAULT 0
        """
      );
    }
  }


  Future<int> insertFood(Food food) async {
    Database db = await instance.database;

    if(food.id == null){
      //생성
      final _map = food.toMap();
      return await db.insert(foodTable, _map);
    }else{
      //변경
      final _map = food.toMap();
      return await db.update(foodTable, _map, where: "id = ? ", whereArgs: [food.id]);
    }
  }
  //특정 날짜 불러와줘
  Future<List<Food>> queryFoodByDate(int date) async {
    Database db = await instance.database;
    List<Food> foods = [];

    final query = await db.query(foodTable, where: "date = ?", whereArgs: [date]);

    for(final r in query){
      foods.add(Food.fromDB(r));
    }
    return foods;
  }
  Future<List<Food>> queryAllFood() async {
    Database db = await instance.database;
    List<Food> foods = [];

    final query = await db.query(foodTable);

    for(final r in query){
      foods.add(Food.fromDB(r));
    }
    return foods;
  }

  Future<int> insertWorkout(WorkOut workout) async {
    Database db = await instance.database;

    if(workout.id == null){
      final map = workout.toMap();
      return await db.insert(workoutTable, map);
    }else{
      final map = workout.toMap();
      return await db.update(workoutTable, map, where: "id = ? ", whereArgs: [workout.id]);
    }
  }

  Future<List<WorkOut>> queryWorkoutByDate(int date) async {
    Database db = await instance.database;
    List<WorkOut> workouts = [];

    final query = await db.query(workoutTable, where: "date = ?", whereArgs: [date]);

    for(final r in query){
      workouts.add(WorkOut.fromDB(r));
    }
    return workouts;
  }
  Future<List<WorkOut>> queryAllWorkout() async {
    Database db = await instance.database;
    List<WorkOut> workouts = [];

    final query = await db.query(workoutTable);

    for(final r in query){
      workouts.add(WorkOut.fromDB(r));
    }
    return workouts;
  }

  Future<int> insertEyeBody(EyeBody eyeBody) async {
    Database db = await instance.database;

    if(eyeBody.id == null){
      final map = eyeBody.toMap();
      return await db.insert(bodyTable, map);
    }else{
      final map = eyeBody.toMap();
      return await db.update(bodyTable, map, where: "id = ?", whereArgs: [eyeBody.id]);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db = await instance.database;
    List<EyeBody> bodies = [];

    final query = await db.query(bodyTable, where: "date = ?", whereArgs: [date]);

    for(final r in query){
      bodies.add(EyeBody.fromDB(r));
    }
    return bodies;
  }

  Future<List<EyeBody>> queryAllEyeBody() async {
    Database db = await instance.database;
    List<EyeBody> bodies = [];

    final query = await db.query(bodyTable);

    for(final r in query){
      bodies.add(EyeBody.fromDB(r));
    }
    return bodies;
  }



  Future<int> insertWeight(Weight weight) async {
    Database db = await instance.database;
    List<Weight> _d = await queryWeightByDate(weight.date);
    if(_d.isEmpty){
      final _map = weight.toMap();

      return await db.insert(weightTable, _map);
    }else{
      final _map = weight.toMap();

      return await db.update(weightTable, _map, where: "date = ?", whereArgs: [weight.date]);
    }
  }
  Future<List<Weight>> queryWeightByDate(int date) async {
    Database db = await instance.database;
    List<Weight> weights = [];

    final query = await db.query(weightTable, where: "date = ?", whereArgs: [date]);

    for(final r in query){
      weights.add(Weight.fromDB(r));
    }
    return weights;
  }
  Future<List<Weight>> queryAllWeight() async {
    Database db = await instance.database;
    List<Weight> weights = [];

    final query = await db.query(workoutTable);

    for(final r in query){
      weights.add(Weight.fromDB(r));
    }
    return weights;
  }
}

