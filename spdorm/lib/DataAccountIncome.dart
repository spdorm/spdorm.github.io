import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class DataAccoutIncomPage extends StatefulWidget {
  int _dormId;
  DataAccoutIncomPage(int dormId) {
    this._dormId = dormId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _DataAccoutIncomPage(_dormId);
  }
}

class _DataAccoutIncomPage extends State<DataAccoutIncomPage> {
  int _dormId;
  _DataAccoutIncomPage(int dormId) {
    this._dormId = dormId;
  }

  String dropdownStatusValue;
  String dropdownValue;

  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธุ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฏาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤษจิกายน",
    "ธ้นวาคม",
  ].toList();

  List<String> _Year = List();
  List lst = new List();
  var now = new DateTime.now();
  String _selectedYear;
  int total = 0;

  void onYearChange(String item) {
    lst.clear();
    setState(() {
      _selectedYear = item;
      _cardTop();
      _cardShow();
    });
  }

  void _changDate() {
    for (int i = (now.year + 543); i > (now.year + 543) - 5; i--) {
      _Year.add((i).toString());
    }
    _selectedYear = _Year.first;
  }

  @override
  void initState() {
    super.initState();
    _changDate();
    _cardTop();
    _cardShow();
//################################################################################
    // Container button = Container(
    //   margin: EdgeInsets.only(top: 10),
    //   child: Center(
    //     child: RaisedButton.icon(
    //       onPressed: () {},
    //       icon: Icon(Icons.search),
    //       label: Text('ค้นหา'),
    //       color: Colors.blue[500],
    //     ),
    //   ),
    // );
    // setState(() {
    //   lst.add(button);
    // });
  }

  void _cardTop() {
    //###################################################################################
    Card cardTop = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 20.0),
                child: Text("โปรดเลือกปี พ.ศ เพื่อดูประวัติ    ปี  :"),
              ),
              new DropdownButton<String>(
                  value: _selectedYear,
                  items: _Year.map((String dropdownValue) {
                    return new DropdownMenuItem(
                        value: dropdownValue, child: new Text(dropdownValue));
                  }).toList(),
                  onChanged: (String value) {
                    onYearChange(value);
                  }),
            ],
          ),
        ],
      ),
    );
    setState(() {
      lst.add(cardTop);
    });
  }

  void _cardShow() {
    //##############F#################################################################
    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดประวัติรายรับ-รายจ่าย'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
//##############F#################################################################
    http.post('${config.API_url}/income/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      for (int i = 0; i < temp.length; i++) {
        Map<String, dynamic> dataMap = temp[i];
        total = 0;
        List value = new List(12);
        if (dataMap['dateTime'].toString().substring(5, 6) == "0" &&
            dataMap['dateTime'].toString().substring(0, 4) ==
                '${int.parse('${_selectedYear}') - 543}') {
                  int index = 0;
          for (int j = 0; j < _Month.length; j++) {
            if (dataMap['dateTime'].toString().substring(6, 7) == '${j}') {
              total += int.parse(dataMap['incomeRent']);  
              value[j] = total; 
              index=j;  
              print(value[7]);         
            }            
          }
          _table(_Month[index - 1], value[index].toString(), dataMap['expend'],
                  dataMap['profit']);
        } else if (dataMap['dateTime'].toString().substring(5, 6) == "1" &&
            dataMap['dateTime'].toString().substring(0, 4) ==
                '${int.parse('${_selectedYear}') - 543}') {
          for (int i = 0; i < _Year.length; i++) {
            if (dataMap['dateTime'].toString().substring(6, 7) ==
                '${_Month.indexOf('${i}') + 1}') {
              //_table(dataMap);
            }
          }
        }
      }
    });
  }

  void _table(String month, String income, String expend, String profit) {
    // print(month);
    Card cardShow = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Container(
            child: Table(
                border: TableBorder.all(width: 0.2, color: Colors.black),
                columnWidths: {
              0: FractionColumnWidth(.3)
            },
                children: [
              TableRow(children: [
                Text(
                  "เดือน",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "รายรับ",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "รายจ่าย",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "กำไร",
                  textAlign: TextAlign.center,
                ),
              ]),
              
              month != ""
              ?TableRow(children: [
                      Text(
                        '${month}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${income}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '2',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '3',
                        textAlign: TextAlign.center,
                      ),
                    ])
                    :null
            ])),
      ),
    );
    setState(() {
      lst.add(cardShow);
    });
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('ประวัติรายรับ-รายจ่าย'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        itemBuilder: widgetBuilder,
        itemCount: lst.length,
      ),
    );
  }
}
