import 'dart:async';

import 'package:flutter_app/src/calculated_salary.dart';
import 'package:flutter_app/src/salary.dart';
import 'package:flutter_app/src/shift.dart';
import 'package:flutter_app/src/storage/salary_storage.dart';

class SalaryCalculator {
  final SalaryStorage salaryStorage;

  SalaryCalculator(this.salaryStorage);

  Future<Map<String, CalculatedSalary>> calculateSalary(
      List<Shift> shifts) async {
    Map<String, Salary> salaryMap = await salaryStorage.readSalaries();
    return groupShiftsByBarista(shifts).map((barista, shifts) {
      int totalMinutes = 0;
      double totalEarnings = 0.0;
      shifts.forEach((s) {
        totalMinutes += s.duration;
        totalEarnings += s.earnings;
      });
      double totalHours = totalMinutes / 60;
      Salary baristaSalary = salaryMap[barista];
      if (baristaSalary == null) {
        return MapEntry<String, CalculatedSalary>(
            barista, new CalculatedSalary(totalHours, 0, '', 0, 0, 0));
      }
      double percentageFromEarnings = double.tryParse(
          (totalEarnings * baristaSalary.percentage / 100).toStringAsFixed(2));
      double totalForHours = (baristaSalary.amount * totalHours);
      double totalAmount = double.tryParse(
          (totalForHours + percentageFromEarnings).toStringAsFixed(2));
      return MapEntry<String, CalculatedSalary>(
          barista,
          new CalculatedSalary(
              totalHours,
              totalAmount.round(),
              baristaSalary.currency,
              totalEarnings.round(),
              percentageFromEarnings.round(),
              totalForHours.round()));
    });
  }

  static Map<String, List<Shift>> groupShiftsByBarista(List<Shift> shifts) {
    var baristaShiftsMap = <String, List<Shift>>{};
    for (var s in shifts) {
      var list = baristaShiftsMap.putIfAbsent(s.barista, () => []);
      list.add(s);
    }
    return baristaShiftsMap;
  }
}
