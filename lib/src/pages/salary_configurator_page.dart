import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/UI/AppColors.dart';
import 'package:flutter_app/src/salary.dart';
import 'package:flutter_app/src/storage/salary_data_source.dart';
import 'package:flutter_app/src/storage/salary_storage.dart';

class SalaryConfiguratorPage extends StatefulWidget {
  final SalaryStorage _salaryStorage = new SalaryStorage();

  @override
  State createState() {
    return SalaryConfiguratorState();
  }
}

class SalaryConfiguratorState extends State<SalaryConfiguratorPage> {
  Future<Map<String, Salary>> _salariesMapFuture;

  @override
  void initState() {
    super.initState();
    _updateSalaries();
  }

  _updateSalaries() {
    _salariesMapFuture = widget._salaryStorage.readSalaries();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Salary Config',
            style: new TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.kindaOrange,
        ),
        body: new FutureBuilder(
            future: _salariesMapFuture,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Salary>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  color: AppColors.kindaMint,
                  child: ListView(children: <Widget>[
                    new PaginatedDataTable(
                      rowsPerPage: 5,
                      header: Text(''),
                      columns: <DataColumn>[
                        new DataColumn(
                            label: Text('Barista',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 33.0,
                                    color: AppColors.kindaBlack))),
                        new DataColumn(
                            label: Text(
                          'Money',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 33.0,
                              color: AppColors.kindaBlack),
                        )),
                      ],
                      source: new SalaryDataSource(snapshot.data),
                    ),
                  ]),
                );
              } else {
                return new Center(
                    child: new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.kindaBlack)));
              }
            }),
        persistentFooterButtons: <Widget>[
          IconButton(
              tooltip: 'Add',
              icon: new Icon(Icons.add),
              onPressed: () => _addNewSalary(context),
              splashColor: AppColors.kindaOrange),
          IconButton(
            tooltip: 'Delete',
            icon: new Icon(Icons.delete),
            onPressed: () => _removeSalaryInfo(context),
            splashColor: AppColors.kindaOrange,
          )
        ],
      ),
    );
  }

  final _formKeyAdd = GlobalKey<FormState>();
  final _formKeyRemove = GlobalKey<FormState>();

  String _newBarista;
  int _newBristaSalary;
  String _newBaristaCurrency;
  int _newBristaPercentage;
  String _removeBaristaName;

  _addNewSalary(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Form(
              key: _formKeyAdd,
              child: new Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'Dritan Alsela', labelText: 'Barista name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter barista name';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        _newBarista = value;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(hintText: '8', labelText: 'Salary'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter salary';
                      } else if (int.tryParse(value) == null) {
                        return 'Salary must be a number';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        _newBristaSalary = int.parse(value);
                      });
                    },
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                        hintText: 'pln or uah', labelText: 'Currency'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter currency';
                      } else if (value != 'pln' && value != 'uah') {
                        return 'Currency must be pln or uah';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        _newBaristaCurrency = value;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    decoration: new InputDecoration(
                        hintText: '5', labelText: 'Percentage'),
                    validator: (value) {
                      print('Value =' + value);
                      int parsedPercentage = int.tryParse(value);
                      if (parsedPercentage == null) {
                        return 'Percentage must be a number';
                      } else if (parsedPercentage < 0 ||
                          parsedPercentage > 100) {
                        return 'Percentage must be between 0 and 100';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        _newBristaPercentage = int.parse(value);
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKeyAdd.currentState.validate()) {
                          _formKeyAdd.currentState.save();
                          Map<String, Salary> temp = {
                            _newBarista: new Salary(_newBristaSalary,
                                _newBaristaCurrency, _newBristaPercentage)
                          };
                          widget._salaryStorage.addSalary(temp).then((file) {
                            setState(() {
                              _updateSalaries();
                            });
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      color: AppColors.kindaOrange,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  _removeSalaryInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Form(
              key: _formKeyRemove,
              child: new Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      hintText: 'Dritan Alsela',
                      labelText: 'Barista name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter barista name';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        _removeBaristaName = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKeyRemove.currentState.validate()) {
                          _formKeyRemove.currentState.save();
                          widget._salaryStorage
                              .removeSalary(_removeBaristaName)
                              .then((file) {
                            setState(() {
                              _updateSalaries();
                            });
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'remove',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: AppColors.kindaOrange,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
      barrierDismissible: true,
    );
  }
}
