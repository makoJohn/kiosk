import 'package:flutter/material.dart';
import 'package:flutter_app/src/UI/AppColors.dart';
import 'package:flutter_app/src/pages/salary_page.dart';
import 'package:flutter_app/src/pages/salary_configurator_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _startTime;
  DateTime _endTime;

  bool _kiev = false;
  bool _powisle = false;
  bool _wielopole = false;

  _selectStartTime(BuildContext context) async {
    var selectedStart = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(new Duration(days: 300)));
    if (selectedStart != null) {
      setState(() {
        _startTime = DateTime.utc(
            selectedStart.year, selectedStart.month, selectedStart.day);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    var selectedEnd = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime.now().add(new Duration(days: 300)));
    if (selectedEnd != null) {
      setState(() {
        _endTime =
            DateTime.utc(selectedEnd.year, selectedEnd.month, selectedEnd.day);
      });
    }
  }

  bool _datesValid() {
    return _startTime != null &&
        _endTime != null &&
        _startTime.compareTo(_endTime) < 1;
  }

  bool _kioskSelected() {
    return _kiev || _powisle || _wielopole;
  }

  void _onKievChange(bool value) {
    setState(() {
      _kiev = value;
    });
  }

  void _onWielopoleChange(bool value) {
    setState(() {
      _wielopole = value;
    });
  }

  void _onPowisleChange(bool value) {
    setState(() {
      _powisle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        backgroundColor: AppColors.kindaMint,
        appBar: new AppBar(
          title: new Text(
            'Coffee Kiosk',
            style: new TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.kindaOrange,
        ),
        drawer: new Drawer(
          child: Material(color: Color.fromARGB(55, 171, 220, 200),
            child: new ListView(
              children: <Widget>[
                new DrawerHeader(
                  child: null,
                  decoration: new FlutterLogoDecoration(),
                ),
                new ListTile(
                  title: new Text('Salary configurator'),
                  trailing: new Icon(Icons.monetization_on),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new SalaryConfiguratorPage()));
                  },
                ),
                new Divider(),
                new ListTile(
                  title: new Text('Cancel'),
                  trailing: new Icon(Icons.cancel),
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                child: new Text(
                  _startTime != null
                      ? new DateFormat.yMMMd().format(_startTime)
                      : 'Choose start date',
                  style:
                      new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                padding: new EdgeInsets.all(10.0),
              ),
              new RaisedButton(
                  color: AppColors.kindaBlack,
                  child: new Text(
                    'Start date',
                    style: new TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () => _selectStartTime(context)),
              new Padding(
                child: new Text(
                  _endTime != null
                      ? new DateFormat.yMMMd().format(_endTime)
                      : 'Choose end date',
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: new EdgeInsets.all(10.0),
              ),
              new RaisedButton(
                  color: AppColors.kindaBlack,
                  child: new Text(
                    'End date',
                    style: new TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () => _selectEndTime(context)),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new Padding(
                child: new Text(
                  'Select city',
                  style:
                      new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Checkbox(
                    value: _kiev,
                    onChanged: (value) {
                      _onKievChange(value);
                    },
                    activeColor: AppColors.kindaBlack,
                  ),
                  new Text(
                    'Kiev',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Checkbox(
                      value: _powisle,
                      onChanged: (value) {
                        _onPowisleChange(value);
                      },
                      activeColor: AppColors.kindaBlack),
                  new Text('Powisle',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  new Checkbox(
                      value: _wielopole,
                      onChanged: (value) {
                        _onWielopoleChange(value);
                      },
                      activeColor: AppColors.kindaBlack),
                  new Text('Wielopole',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ],
              ),
              new Padding(padding: new EdgeInsets.all(30.0)),
              new RaisedButton(
                color: AppColors.kindaOrange,
                padding: new EdgeInsets.all(10.0),
                child: new Text(
                  'Calculate',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () {
                  if (_datesValid() && _kioskSelected()) {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new SalaryPage(
                            _startTime,
                            _endTime.add(Duration(days: 1)),
                            _kiev,
                            _powisle,
                            _wielopole)));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
