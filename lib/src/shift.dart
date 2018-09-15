class Shift {
  final String barista;
  final String kiosk;
  final int duration;
  final int earnings;

  Shift(this.barista, this.kiosk, this.duration, this.earnings);

  @override
  String toString() {
    return "Barista=" +
        barista +
        ", kiosk=" +
        kiosk +
        ", duration=" +
        duration.toString() +
        ", earnings=" +
        earnings.toString();
  }
}
