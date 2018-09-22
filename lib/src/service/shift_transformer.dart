import 'package:flutter_app/src/shift.dart';
import 'package:googleapis/calendar/v3.dart' as googleCalendar;

class ShiftTransformer {
  static List<Shift> transformEvents(List<googleCalendar.Event> events) {
    return events.map((e) {
      var durationInMinutes =
          e.end.dateTime.difference(e.start.dateTime).inMinutes;

      var earnings = 0;
      if (e.description != null) {
        var parsedDescription = int.tryParse(e.description);
        if (parsedDescription != null) {
          earnings = parsedDescription;
        }
      }

      return Shift(e.summary.trim(), e.organizer.displayName, durationInMinutes,
          earnings);
    }).toList();
  }
}
