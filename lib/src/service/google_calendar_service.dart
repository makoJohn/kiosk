import 'dart:async';

import 'package:googleapis/calendar/v3.dart' as googleCalendar;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleCalendarService {
  static Future<googleCalendar.Events> callCalendarApi(
      DateTime start, DateTime end, String calendarId) async {
    var events = await clientViaServiceAccount(_accountCredentials, _scopes)
        .then((httpClient) {
      googleCalendar.CalendarApi calendarApi =
          new googleCalendar.CalendarApi(httpClient);
      return calendarApi.events.list(calendarId, timeMin: start, timeMax: end);
    });
    return events;
  }

  static const WIELOPOLE_ID =
      'dbucdvkkcpuhhio7a04tg9k0rc@group.calendar.google.com';
  static const POWISLE_ID =
      '0f889s04a0bs6cpag2aga2873k@group.calendar.google.com';
  static const ENTHUSIAST_ID =
      'ddnl23teuevo49otk6e4f9kuv0@group.calendar.google.com';
  static const RUSANOVKA_BULBAR_ID =
      'g53r6jc7fp4tt887l8an0krj5o@group.calendar.google.com';

  static final _accountCredentials =
      new ServiceAccountCredentials.fromJson(r'''{
  "private_key_id": "cbcd8dec6bdeb6a34115b865e09e0cb399bb6d06",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCY6fHISy3GDFyb\nT8yZicjvcrOqeAnm1xqcnMYalEHVEh302T2FnMelBHhqXo1H/jCjMMZuxrP/+Ojh\n+8/TN2N0ZT7/D/5lCx+yiQJpBbHSutezp4y4ItJkhxKEi6jlG8+Rz0bnQwfikNRV\nPA1/q749JdLkBwmTAWP95rQnExajm9+SxPKp1J61AZ/bS/Ugdv4czVcfn8x0HAt+\n03KQ/TbYbvhhvBoifrNZGXGqi1VGq5MJmztzxi/1Q1ypDZJJc2IdN0KjTbVCLLi2\nXGlr2ZL2nlkwetiglYw8KGGGhB7kZmUChIDFJIz1u1DsGP/uD7u0X4bIOq9u+r/F\nKv+BPttNAgMBAAECggEABjULl9+Ctn+5S/iw9n6YWy1Ny8Ve/tw2fABag6kHBG4y\n1xtGcGO32vlT0LA740iXPYNKWs7SxGOcmH0kp49KXebfksevF6JG9slcVq+2KIwQ\ncNOEASmGCYdOIiFFNDUCd7RxTWFJiFHsEfWub+35z/j2wZjjiPB32E5YJnSTk6/n\nr1PH1ltQdtfXPVXoPv536CuIUaJcnXpb+gaHUEd9X/RWcepOXMB1AC+/s7EfK0fH\n0UZtfEZS3VbaRCEqduspUwznbpA3SMlFcXqefE7qMKcpR0fa+MwhnQGAOCVs3VQY\njyGZ2T4qrUI1h9LYX9nbxkIL4UgTZS4vU0+ovfOORQKBgQDXDu2S6eHQir6vsgyF\nMwOtVY3ATPNUB3khWFlNz2u4dCgpW4tDhX4e6eTBLrB2aBhFwR3FepJgafmF32cB\net9OSbsF7u3XpvTfD5IdI3biuwMZiVK0FHxIchNKX/l7hupjIMhMgOHHszstCHgO\nNdSR7EzuONakHHoNsxN6u7A79wKBgQC2Bli4rw/RxkhiFCjdH9ZojKrF1KEG/IAh\n5Mz2tpXLCwlHvA36FX9uz67YogKwxPONly5yuvX8jB4Xzs4vzOoVFrohPAbFzjrg\nFz5J8rxTUVH+RXCcUjD2LxRMhvb1V/Bj+x/FRBlV+ohXA/UX0sSMqUPBZMQMGXrG\n549yROcp2wKBgHpbRPHsXY0QE3PVAmiaYMIyxeaeIWcypUlCgfTSSYB1nhABxJdT\nETG3c24yCTYk/YJaYHzlwvhV8yCmvW1LIlfhfSXgDbQ/ilyK+F/ZuJ9BNX9G8SYB\n7cAuHymWt1P/q8VgdnWIcmzzXXy+r8et+tZXMmHrNrvCc/LtauzOcnN7AoGAKu2U\nPvoKYQ7CQ189w+ieSEnkfIOI9nzWOygarpSg/yG7Lo/LPA+V3ixcr/qFZ+sLBXmC\nGsy89rKU5kh/mAZbrl2NyAjAECZy/CZ/KjF0+LFVBQKbbEJ2CZlQ0DuEQphauTmg\nZIWK9BwBy4PDabrrX8ELmbCKC9B2hDJYQjq9ycECgYEAxbwFiXJkCeKNez1YMq1V\nTO9rN0eUxromzuy8Ql0bkOl0x9Ghf/SSvNlGZgH1iAZP62vhYojdTAwVliI9+bS9\nL1Nga2bVqO19zQEXO19h0cSYAXlm5T46tO25KYMynKb7UWhcH/9Yf4qhAUe6t9DA\nxVsZHu4Xcaymhovqj1FK04o=\n-----END PRIVATE KEY-----\n",
  "client_email": "default@makojon-203720.iam.gserviceaccount.com",
  "client_id": "106964242060563089564",
  "type": "service_account"
  }
''');

  static const _scopes = const [
    googleCalendar.CalendarApi.CalendarReadonlyScope
  ];
}
