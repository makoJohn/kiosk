import 'package:flutter/material.dart';
import 'package:flutter_app/src/salary.dart';

class SalaryDataSource extends DataTableSource {
  final Map<String, Salary> _salariesMap;

  SalaryDataSource(this._salariesMap);

  @override
  DataRow getRow(int index) {
    final MapEntry<String, Salary> entry = _salariesMap.entries.toList()[index];
    return new DataRow(cells: [
      new DataCell(new Text(
        '${entry.key}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25.0,
          fontStyle: FontStyle.italic,
        ),
      )),
      new DataCell(
        new Text('${entry.value}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              fontStyle: FontStyle.italic,
            )),
      ),
    ]);
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return _salariesMap.length;
  }
}
