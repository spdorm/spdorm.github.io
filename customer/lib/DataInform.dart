import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class DataInfromPage extends StatefulWidget {
  int _dormId;
  DataInfromPage(int dormId) {
    this._dormId = dormId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _DataInfromPage(_dormId);
  }
}

class _DataInfromPage extends State<DataInfromPage> {
  int _dormId;
  _DataInfromPage(int dormId) {
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

  String _selectedMonth, _selectedYear;

  void onMonthChange(String item) {
    lst.clear();
    setState(() {
      _selectedMonth = item;
//###################################################################################
      _lable();
      _changDate();
      _show();
//################################################################################
      print(_selectedMonth);
    });
  }

  void onYearChange(String item) {
    lst.clear();
    setState(() {
      _selectedYear = item;
      _lable();
      _changDate();
      _show();
      print(_selectedYear);
    });
  }

  void _convertYear() {
    for (int i = (now.year + 543); i > (now.year + 543) - 5; i--) {
      _Year.add((i).toString());
    }
    _selectedYear = _Year.first;
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = _Month.first;
    _convertYear();
    _lable();
//###################################################################################
    _changDate();
//################################################################################
    //_btSearch();
//##############F#################################################################
  }

  void _lable() {
    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดประวัติข้อมูลการแจ้งซ่อม'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
  }

  void _changDate() {
    Card cardTop = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10,bottom: 10),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 20.0),
                child: Text("เดือน :"),
              ),
              new DropdownButton<String>(
                  value: _selectedMonth,
                  items: _Month.map((String dropdownStatusValue) {
                    return new DropdownMenuItem(
                        value: dropdownStatusValue,
                        child: new Text(dropdownStatusValue));
                  }).toList(),
                  onChanged: (String value) {
                    onMonthChange(value);
                  }),
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 20.0),
                child: Text("ปี :"),
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

  void _btSearch() {
    Container button = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.search),
          label: Text('ค้นหา'),
          color: Colors.blue[500],
        ),
      ),
    );
    setState(() {
      lst.add(button);
    });
  }

  void _show() {
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          Map<String, dynamic> data = temp[i];
          //####################################################
          if (data['dateTime'].toString().substring(5, 6) == "0" &&
              data['dateTime'].toString().substring(0, 4) ==
                  '${int.parse('${_selectedYear}') - 543}') {
            if (data['dateTime'].toString().substring(6, 7) ==
                '${_Month.indexOf('${_selectedMonth}') + 1}') {
              _createCard(temp[i]);
            }
            // else{
            //   Container alert = Container(
            //     margin: EdgeInsets.all(100),
            //     child: Center(
            //       child: Text('ไม่พบข้อมูล',style: TextStyle(color: Colors.red),),
            //     ),
            //   );
            //   setState(() {
            //    lst.add(alert);
            //   });
            // }
          } else if (data['dateTime'].toString().substring(5, 6) == "1" &&
              data['dateTime'].toString().substring(0, 4) ==
                  '${int.parse('${_selectedYear}') - 543}') {
            if (data['dateTime'].toString().substring(6, 7) ==
                '${_Month.indexOf('${_selectedMonth}') + 1}') {
              _createCard(temp[i]);
            }
            // else{
            //   Container alert = Container(
            //     margin: EdgeInsets.all(100),
            //     child: Center(
            //       child: Text('ไม่พบข้อมูล',style: TextStyle(color: Colors.red),),
            //     ),
            //   );
            //   setState(() {
            //    lst.add(alert);
            //   });
            // }
          }
          //##########################################################
        }
      }
    });
  }

  void _createCard(Map<String, dynamic> data) {
    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": data['dormId'].toString(),
      "roomId": data['roomId'].toString()
    }).then((response) {
      Map jsonData = jsonDecode(response.body);
      Map<String, dynamic> roomDataMap = jsonData['data'];

      if (jsonData['status'] == 0) {
        Color color;
        String status;

        if (data['fixStatus'] == "active") {
          color = Colors.yellow[600];
          status = "รอดำเนินการ";
        } else if (data['fixStatus'] == "success") {
          color = Colors.green[600];
          status = "ดำเนินการแล้ว";
        }

        Card cardShow = Card(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'ห้อง : ${roomDataMap['roomNo']}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.black,                  
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child:
                                Text('รายละเอียดรายการ : ${data['fixDetail']}'),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('สถานะ : '),
                          Text(
                            '${status}',
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
        setState(() {
          lst.add(cardShow);
        });
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    lst.removeRange(2, lst.length);
    setState(() {
      _show();
    });
    return null;
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('ประวัติข้อมูลการแจ้งซ่อม'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5),
          itemBuilder: widgetBuilder,
          itemCount: lst.length,
        ),
        onRefresh: _onRefresh,
      ),
    );
  }
}
