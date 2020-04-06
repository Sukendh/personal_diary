import 'dart:ui';

class AppUtils {


  static String getCurrentWeekDay(){
    var weekDay = new DateTime.now().weekday;
    switch(weekDay){
      case DateTime.sunday:
        return "Sun";
        break;
      case DateTime.monday:
        return "Mon";
        break;
      case DateTime.tuesday:
        return "Tue";
        break;
      case DateTime.wednesday:
        return "Wed";
        break;
      case DateTime.thursday:
        return "Thu";
        break;
      case DateTime.friday:
        return "Fri";
        break;
      case DateTime.saturday:
        return "Sat";
        break;
      default:
        return "WeekDay";
    }
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}