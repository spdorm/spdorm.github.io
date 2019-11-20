import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:flutter/services.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'mainHomeFragment.dart';

class DataAccoutIncomPage extends StatefulWidget {
  int _dormId, _userId;
  DataAccoutIncomPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _DataAccoutIncomPage(_dormId, _userId);
  }
}

class _DataAccoutIncomPage extends State<DataAccoutIncomPage> {
  int _dormId, _userId;
  _DataAccoutIncomPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
    print(_dormId);
    print(_userId);
  }

  List listHeader = List();
  List lst = List();
  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ].toList();

  List<int> totalIncome = List();
  List<int> totalExpen = List();
  List<int> totalProfit = List();
  int index = 0;

  List<String> _Year = List();
  String _selectedYear;
  var now = new DateTime.now();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _changDate();
    _createCardMonth();
    _conDB();
    super.initState();
  }

  void onYearChange(String item) {
    setState(() {
      _selectedYear = item;
      _conDB();
    });
  }

  void _changDate() {
    for (int i = (now.year + 543); i > (now.year + 543) - 5; i--) {
      _Year.add((i).toString());
    }
    _selectedYear = _Year.first;
  }

  void _createCardMonth() {
    lst.clear();
    totalIncome.clear();
    totalExpen.clear();
    totalProfit.clear();
    for (int i = 0; i < _Month.length; i++) {
      totalIncome.add(0);
      totalExpen.add(0);
      totalProfit.add(0);
      Card cardMonth = Card(
        margin: EdgeInsets.all(4.0),
        color: Colors.blue[50],
        child: Column(
          children: <Widget>[
            Text(
              '${_Month[i]}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[300]),
            ),
            Divider(
              color: Colors.red[300],
            ),
            Padding(
              padding: EdgeInsets.only(top: 17),
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(color: Colors.blueGrey[200]),
              ),
            )
          ],
        ),
      );
      setState(() {
        lst.add(cardMonth);
      });
    }
  }

  void _conDB() {
    http.post('${config.API_url}/income/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];
      bool check = false;
      for (int i = 0; i < temp.length; i++) {
        Map<String, dynamic> dataMap = temp[i];

        if (dataMap['dateTime'].toString().substring(5, 6) == "0" &&
            dataMap['dateTime'].toString().substring(0, 4) ==
                '${int.parse('${_selectedYear}') - 543}') {
          for (int j = 0; j < _Month.length; j++) {
            if (dataMap['dateTime'].toString().substring(6, 7) == '${j}') {
              check = true;
              index = j;
              setState(() {
                totalIncome[j - 1] += int.parse(dataMap['incomeRent']);
                totalExpen[j - 1] += int.parse(dataMap['expend']);
                totalProfit[j - 1] += int.parse(dataMap['profit']);
              });
            }
          }
        } else if (dataMap['dateTime'].toString().substring(5, 6) == "1" &&
            dataMap['dateTime'].toString().substring(0, 4) ==
                '${int.parse('${_selectedYear}') - 543}') {
          for (int i = 0; i < _Month.length; i++) {
            if ('${int.parse(dataMap['dateTime'].toString().substring(5, 7)) - 1}' ==
                '${i}') {
              check = false;
              index = i;
              setState(() {
                totalIncome[i] += int.parse(dataMap['incomeRent']);
                totalExpen[i] += int.parse(dataMap['expend']);
                totalProfit[i] += int.parse(dataMap['profit']);
              });
            }
          }
        } else {
          _createCardMonth();
          check = false;
        }
        if (check) {
          _edit(
              index - 1,
              totalIncome[index - 1].toString(),
              totalExpen[index - 1].toString(),
              totalProfit[index - 1].toString());
        } else if (index >= 10) {
          _edit(index, totalIncome[index].toString(),
              totalExpen[index].toString(), totalProfit[index].toString());
        }
      }
    });
  }

  void _edit(int index, String income, String expend, String profit) {
    Card cardMonth = Card(
      margin: EdgeInsets.all(4.0),
      color: Colors.blue[50],
      child: Column(
        children: <Widget>[
          Text(
            '${_Month[index]}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[300]),
          ),
          Divider(
            color: Colors.red[300],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(income, style: TextStyle(color: Colors.indigo)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(expend, style: TextStyle(color: Colors.redAccent)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(profit, style: TextStyle(color: Colors.green[700])),
              ),
            ],
          ),
        ],
      ),
    );
    setState(() {
      lst[index] = cardMonth;
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
         backgroundColor: Colors.red[300],
        title: Text("สรุปยอดรายรับ-รายจ่าย"),
      ),
      body: gridHeader(),
    );
  }

  Widget gridHeader() {
    return new ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return new StickyHeader(
          header: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 3),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: Text("โปรดเลือกปี พ.ศ เพื่อดูประวัติ    ปี  :  ",
                      style: TextStyle(color: Colors.grey[700]),),
                    ),
                    new DropdownButton<String>(
                        value: _selectedYear,
                        items: _Year.map((String dropdownValue) {
                          return new DropdownMenuItem(
                              value: dropdownValue,
                              child: new Text(dropdownValue,style: TextStyle(color: Colors.grey[700]),));
                        }).toList(),
                        onChanged: (String value) {
                          onYearChange(value);
                        }),
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.indigo,
                        ),
                        new Text(
                          ' รายรับ',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.redAccent,
                        ),
                        new Text(
                          ' รายจ่าย',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.green[700],
                        ),
                        new Text(
                          ' กำไร',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
          content: Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: lst.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: bodyBuild,
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
