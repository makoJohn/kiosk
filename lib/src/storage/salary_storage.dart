import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/src/salary.dart';
import 'package:path_provider/path_provider.dart';

class SalaryStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/salaries.txt');
  }

  Future<Map<String, Salary>> readSalaries() async {
    try {
      final file = await _localFile;
      if (file == null) {
        file.createSync();
      }
      // Read the file
      if (!file.existsSync()) {
        return _DEFAULT_SALARY_MAP;
      }

      return await file.readAsString().then((onValue) => _parseContents(onValue));
    } catch (e) {
      // If we encounter an error, return default map
      return _DEFAULT_SALARY_MAP;
    }
  }

  Map<String, Salary> _parseContents(String contents) {
    Map<String, Salary> result = {};
    Map<String, Map>.from(json.decode(contents)).forEach((name, salary) {
      result[name] = Salary(salary['amount'], salary['currency'], salary['percentage']);
    });
    return result;
  }

  Future<File> writeSalaries(var map) async {
    final file = await _localFile;
    if (!file.existsSync()) {
      file.createSync();
    }
    // Write the file
    return file.writeAsString(json.encode(map), flush: true);
  }

  Future<File> addSalary(Map<String, Salary> salaryEntry) async {
    var map = await readSalaries();
    map.addAll(salaryEntry);
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(map));
  }

  Future<File> removeSalary(String barista) async {
    var map = await readSalaries();
    map.remove(barista);
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(map));
  }
}

Map<String, Salary> _DEFAULT_SALARY_MAP = {
  "Алена": new Salary(9, "pln", 0),
  "Настя": new Salary(9, "pln", 0),
  "Настя Одесса": new Salary(9, "pln", 0),
  "Саша": new Salary(20, "uah", 3),
  "Руслан": new Salary(20, "uah", 3),
  "Эля": new Salary(20, "uah", 3),
};
