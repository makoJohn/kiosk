import 'dart:async';

import 'package:flutter_app/src/shift.dart';
import 'package:flutter_app/src/service/google_calendar_service.dart';
import 'package:flutter_app/src/service/shift_transformer.dart';

class ShiftService {
  static Future<List<Shift>> getKievShifts(
      DateTime startTime, DateTime endTime) async {
    List<Shift> kievShifts = [];
    var kiosk = await Future.wait([
      GoogleCalendarService.callCalendarApi(
          startTime, endTime, GoogleCalendarService.RUSANOVKA_BULBAR_ID),
      GoogleCalendarService.callCalendarApi(
          startTime, endTime, GoogleCalendarService.ENTHUSIAST_ID)
    ]);
    for (var events in kiosk) {
      kievShifts.addAll(ShiftTransformer.transformEvents(events.items));
    }
    return kievShifts;
  }

  static Future<List<Shift>> getKrakowShifts(
      DateTime startTime, DateTime endTime) async {
    List<Shift> krakowShifts = [];
    var kiosk = await Future.wait([
      GoogleCalendarService.callCalendarApi(
          startTime, endTime, GoogleCalendarService.WIELOPOLE_ID),
      GoogleCalendarService.callCalendarApi(
          startTime, endTime, GoogleCalendarService.POWISLE_ID)
    ]);
    for (var events in kiosk) {
      krakowShifts.addAll(ShiftTransformer.transformEvents(events.items));
    }
    return krakowShifts;
  }

  static Future<List<Shift>> getPowisleShifts(
      DateTime startTime, DateTime endTime) async {
    return _getShifts(startTime, endTime, GoogleCalendarService.POWISLE_ID);
  }

  static Future<List<Shift>> getWielopoleShifts(
      DateTime startTime, DateTime endTime) async {
    return _getShifts(startTime, endTime, GoogleCalendarService.WIELOPOLE_ID);
  }

  static Future<List<Shift>> _getShifts(
      DateTime startTime, DateTime endTime, String calendarId) async {
    List<Shift> shifts = [];
    var kiosk = await Future.wait([
      GoogleCalendarService.callCalendarApi(startTime, endTime, calendarId),
    ]);
    for (var events in kiosk) {
      shifts.addAll(ShiftTransformer.transformEvents(events.items));
    }
    return shifts;
  }
}
