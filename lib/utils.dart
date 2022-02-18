

List<String> mealTime = ["아침","점심","저녁","간식"];
List<String> mealType = ["균형잡힌","단백질","탄수화물","지방","치팅"];
class Utils{
  static int getFormatTime(DateTime data){
    return int.parse("${data.year}${makeTwoDigit(data.month)}${makeTwoDigit(data.day)}");
  } //parse 형변환

  static DateTime numToDateTime(String date){
    String _d = date.toString();
    int year = int.parse(_d.substring(0,4));
    int month = int.parse(_d.substring(4,6));
    int day = int.parse(_d.substring(6,8));
    return DateTime(year,month,day);
  }

  static DateTime numToDateTime2(int date){
    String _d = date.toString();
    int year = int.parse(_d.substring(0,4));
    int month = int.parse(_d.substring(4,6));
    int day = int.parse(_d.substring(6,8));
    return DateTime(year,month,day);
  }

  static String makeTwoDigit(int num){
    return num.toString().padLeft(2,'0');
  }
  static DateTime stringToDateTime(String date){
    int year = int.parse(date.substring(0,4));
    int month = int.parse(date.substring(4,6));
    int day = int.parse(date.substring(6,8));
    return DateTime(year,month,day);
  }
}