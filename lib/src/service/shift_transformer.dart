import 'package:flutter_app/src/shift.dart';
import 'package:googleapis/calendar/v3.dart' as googleCalendar;

class ShiftTransformer {
  static List<Shift> transformEvents(List<googleCalendar.Event> events) {
    return events.map((e) {
      var durationInMinutes =
          e.end.dateTime.difference(e.start.dateTime).inMinutes;
      var earnings =
          e.description == null ? 0 : int.parse(e.description.trim());
      return Shift(e.summary.trim(), e.organizer.displayName, durationInMinutes,
          earnings);
    }).toList();
  }
}
