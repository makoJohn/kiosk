import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/UI/AppColors.dart';
import 'package:flutter_app/src/calculated_salary.dart';
import 'package:flutter_app/src/service/salary_calculator.dart';
import 'package:flutter_app/src/service/shift_service.dart';
import 'package:flutter_app/src/shift.dart';
import 'package:flutter_app/src/storage/salary_storage.dart';
import 'package:intl/intl.dart';

class SalaryPage extends StatefulWidget {
  final SalaryCalculator salaryCalculator =
      new SalaryCalculator(SalaryStorage());
  final DateTime _startTime;
  final DateTime _endTime;
  final bool _kiev;
  final bool _powisle;
  final bool _wielopole;

  SalaryPage(this._startTime, this._endTime, this._kiev, this._powisle,
      this._wielopole);

  @override
  createState() => new SalaryPageState();
}

class SalaryPageState extends State<SalaryPage> {
  Future<List<Item>> _data;
  int _totalKiev = 0;
  int _totalPowisle = 0;
  int _totalWielopole = 0;
  int _totalKrakow = 0;

  @override
  void initState() {
    super.initState();
    _data = this.getData();
  }

  Future<List<Item>> getData() async {
    List<Item> salaryItems = [];
    if (widget._wielopole && widget._powisle) {
      List<Shift> krakowShifts = await ShiftService.getKrakowShifts(
          widget._startTime, widget._endTime);
      var krakowSalaries =
          await widget.salaryCalculator.calculateSalary(krakowShifts);
      double total = 0.0;
      krakowSalaries.forEach((barista, salary) {
        total += salary.amount;
        salaryItems.add(new Item(barista, salary));
      });
      setState(() {
        _totalKrakow = total.round();
      });
    } else if (widget._wielopole) {
      List<Shift> wielopoleShifts = await ShiftService.getWielopoleShifts(
          widget._startTime, widget._endTime);
      Map<String, CalculatedSalary> wielopoleSalaries =
          await widget.salaryCalculator.calculateSalary(wielopoleShifts);
      double total = 0.0;
      wielopoleSalaries.forEach((barista, salary) {
        total += salary.amount;
        salaryItems.add(new Item(barista, salary));
      });
      setState(() {
        _totalWielopole = total.round();
      });
    } else if (widget._powisle) {
      List<Shift> powisleShifts = await ShiftService.getPowisleShifts(
          widget._startTime, widget._endTime);
      Map<String, CalculatedSalary> powisleSalaries =
          await widget.salaryCalculator.calculateSalary(powisleShifts);
      double total = 0.0;
      powisleSalaries.forEach((barista, salary) {
        total += salary.amount;
        salaryItems.add(new Item(barista, salary));
      });
      setState(() {
        _totalPowisle = total.round();
      });
    }
    if (widget._kiev) {
      List<Shift> kievShifts =
          await ShiftService.getKievShifts(widget._startTime, widget._endTime);
      var kievSalaries =
          await widget.salaryCalculator.calculateSalary(kievShifts);
      double total = 0.0;
      kievSalaries.forEach((barista, salary) {
        total += salary.amount;
        salaryItems.add(new Item(barista, salary));
      });
      setState(() {
        _totalKiev = total.round();
      });
    }
    return salaryItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Salaries (${new DateFormat.MMMd().format(widget._startTime)} - ${new DateFormat.MMMd().format(widget._endTime.add(Duration(days: -1)))})',
            style: new TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.kindaOrange,
        ),
        body: new FutureBuilder(
            future: _data,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(
                      child: new CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.kindaBlack)));
                default:
                  List<Item> data = snapshot.data;
                  var widgets = <Widget>[];
                  widgets.add(new ExpansionPanelList(
                    animationDuration: Duration(milliseconds: 300),
                    children: createSalariesPanels(data),
                    expansionCallback: (index, bool expanded) {
                      setState(() {
                        data[index].isExpanded = !expanded;
                      });
                    },
                  ));
                  widgets.addAll(createTotalSalariesWidgets());
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(top: 5.0),
                    child: SafeArea(
                      child: Column(
                        children: widgets,
                      ),
                    ),
                  );
              }
            }),
        backgroundColor: AppColors.kindaMint,
      ),
    );
  }

  static Widget createTotalCard(String text) {
    return Container(
      width: double.infinity,
      child: new Card(
        color: AppColors.kindaBlack,
        child: Center(
          child: new Padding(
              padding: EdgeInsets.all(12.0),
              child: new Text(text,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))),
        ),
      ),
    );
  }

  List<Widget> createTotalSalariesWidgets() {
    List<Widget> totalSalaries = [];
    if (widget._kiev) {
      totalSalaries.add(createTotalCard('KIEV: $_totalKiev uah'));
    }
    if (widget._wielopole && widget._powisle) {
      totalSalaries.add(createTotalCard('KRAKOW: $_totalKrakow pln'));
    } else if (widget._powisle) {
      totalSalaries.add(createTotalCard('POWISLE: $_totalPowisle pln'));
    } else if (widget._wielopole) {
      totalSalaries.add(createTotalCard('WIELOPOLE: $_totalWielopole pln'));
    }
    return totalSalaries;
  }

  static List<ExpansionPanel> createSalariesPanels(List<Item> data) {
    if (data == null) {
      return [];
    }
    return data.map((item) {
      return new ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: new Text(
                item.headerText,
                style: TextStyle(color: AppColors.kindaBlack, fontSize: 25.0),
              ),
            );
          },
          body: Container(
            decoration: BoxDecoration(color: Color.fromARGB(54, 54, 54, 10)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '${item.calculatedSalary.totalHours} hours = ${item.calculatedSalary.totalForHours} ${item.calculatedSalary.currency}',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                        'cash ${item.calculatedSalary.totalEarnings} = ${item.calculatedSalary.percentageFromEarnings}% ${item.calculatedSalary.currency}',
                        style: TextStyle(
                            fontSize: 23.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kindaOrange)),
                  ],
                ),
              ],
            ),
          ),
          isExpanded: item.isExpanded);
    }).toList();
  }
}

class Item {
  String barista;
  CalculatedSalary calculatedSalary;
  bool isExpanded;

  Item(String barista, CalculatedSalary calculatedSalary) {
    this.barista = barista;
    this.calculatedSalary = calculatedSalary;
    this.isExpanded = false;
  }

  String get headerText =>
      '$barista = ${calculatedSalary.amount} ${calculatedSalary.currency}';
}
