class DateTimeUtils {
  static startDayOfWeek(DateTime date) {
    return getDate(date.subtract(Duration(days: date.weekday - 1)));
  }

  static int startDayOfDay() {
    DateTime startOfDay = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 000);
    return startOfDay.millisecondsSinceEpoch;
  }

  static int endDayOfDay() {
    DateTime startOfDay = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59, 999);
    return startOfDay.millisecondsSinceEpoch;
  }

  static endDayOfWeek(DateTime date) {
    return getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
  }

  static int endOfMonthMilliseconds(DateTime now) {
    var beginningNextMonth =
        (now.month < 12) ? new DateTime(now.year, now.month + 1, 1, 23, 59, 59, 999) : new DateTime(now.year + 1, 1, 1, 23, 59, 59, 999);
    var lastDay = beginningNextMonth.subtract(new Duration(days: 1)).millisecondsSinceEpoch;
    return lastDay;
  }

  static int startOfMonthMilliseconds(DateTime now) {
    var beginningCurrentMonth = new DateTime(now.year, now.month, 1, 0, 0, 0, 000);
    var firstDay = beginningCurrentMonth.millisecondsSinceEpoch;
    return firstDay;
  }

  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  bool isToday(int unixMilliseconds) {
    if (unixMilliseconds >= startDayOfDay() && unixMilliseconds <= endDayOfDay()) {
      return true;
    } else {
      return false;
    }
  }
}
