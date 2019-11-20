import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'dart:convert';
import 'listPayment.dart';

class PaymentNotification extends StatefulWidget {
  int _dormId, _userId, _roomId;
  PaymentNotification(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _PaymentNotification(_dormId, _userId, _roomId);
  }
}

class _PaymentNotification extends State<PaymentNotification> {
  int _dormId, _userId, _roomId;
  _PaymentNotification(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  TextEditingController priceWater = TextEditingController();
  TextEditingController priceElectricity = TextEditingController();
  TextEditingController priceOther = TextEditingController();
  TextEditingController priceFix = TextEditingController();
  TextEditingController priceTotal = TextEditingController();

  String roomNo, roomPrice = "";
  int _customerId;
  int intRoomPrice = 0;
  bool check = false;
  String _selectedMonth, _date;
  var now = new DateTime.now();

  List<String> _month = [
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

  @override
  void initState() {
    super.initState();
    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString()
    }).then((respone) {
      Map jsonData = jsonDecode(respone.body) as Map;
      Map<String, dynamic> listData = jsonData["data"];

      if (jsonData["status"] == 0) {
        roomNo = listData["roomNo"];
        roomPrice = listData["roomPrice"];
        _customerId = listData["customerId"];
        check = true;

        // http.post('${config.API_url}/invoice/list', body: {
        //   "dormId": _dormId.toString(),
        //   "userId": _customerId.toString(),
        //   "roomId": _roomId.toString()
        // }).then((response) {
        //   print(response.body);
        //   Map jsonData = jsonDecode(response.body);
        //   List temp = jsonData["data"];

        //   if (jsonData["status"] == 0 && temp.isNotEmpty) {
        //     var now = new DateTime.now();
        //     for (int i = 0; i < temp.length; i++) {
        //       List data = temp[i];
        //       // String _year = data[1].toString().substring(0, 4);
        //       // String _month = data[1].toString().substring(6, 7);

        //       // if (_year == now.year.toString() &&
        //       //     _month == now.month.toString()) {
        //       //   return Alert(
        //       //     context: context,
        //       //     type: AlertType.warning,
        //       //     title: "คำเตือน!",
        //       //     desc: "มีการเพิ่มใบแจ้งชำระเดือนนี้แล้ว",
        //       //     buttons: [
        //       //       DialogButton(
        //       //         child: Text(
        //       //           "ตกลง",
        //       //           style: TextStyle(color: Colors.white, fontSize: 20),
        //       //         ),
        //       //         onPressed: () => Navigator.pop(context),
        //       //         width: 120,
        //       //       )
        //       //     ],
        //       //   ).show();
        //       // }
        //     }
        //   }
        // });
      }
      set();
    });
  }

  void onMonthChange(String item) {
    setState(() {
      _selectedMonth = item;
      print(_selectedMonth);
    });
    for (int i = 0; i < 12; i++) {
      if (_selectedMonth == _month[i]) {
        if (i < 9 && now.day < 10) {
          _date = "${now.year.toString()}-0${i + 1}-0${now.day.toString()}";
        } else if (i >= 9 && now.day < 10) {
          _date = "${now.year.toString()}-${i + 1}-0${now.day.toString()}";
        } else if (i >= 9 && now.day > 10) {
          _date = "${now.year.toString()}-${i + 1}-${now.day.toString()}";
        } else if (i < 9 && now.day > 10) {
          _date = "${now.year.toString()}-0${i + 1}-${now.day.toString()}";
        }
      }
    }
    print(_date);
  }

  void onPaymentNotification() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = '${_userId}';
    param["roomId"] = _roomId.toString();
    param["roomPrice"] = roomPrice.toString();
    param["priceWater"] = priceWater.text;
    param["priceElectricity"] = priceElectricity.text;
    param["priceOther"] = priceOther.text;
    param["priceFix"] = priceFix.text;
    param["priceTotal"] = sum().toString();
    param["dateTime"] = _date.toString();
    param["invoiceStatus"] = "ยังไม่จ่าย";

    http.post('${config.API_url}/invoice/add', body: param).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        return SweetAlert.show(context,
            title: "สำเร็จ!",
            subtitle: "เพิ่มใบแจ้งชำระเรียบร้อยแล้ว",
            style: SweetAlertStyle.success);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => HomeDorm(_dormId, _userId)));
      }
    });
  }

  int sum() {
    int total1 = 0;
    int total2 = 0;
    int total3 = 0;
    int total4 = 0;

    if (priceElectricity.text != "") {
      total1 = int.parse(priceElectricity.text);
    }
    if (priceFix.text != "") {
      total2 = int.parse(priceFix.text);
    }
    if (priceOther.text != "") {
      total3 = int.parse(priceOther.text);
    }
    if (priceWater.text != "") {
      total4 = int.parse(priceWater.text);
    }
    if (roomPrice != "") {
      intRoomPrice = int.parse(roomPrice);
    }
    return total1 + total2 + total3 + total4 + intRoomPrice;
  }

  void set() {
    if (check) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        backgroundColor: Colors.red[300],
        title: new Text('การเพิ่มใบแจ้งชำระ'),
      ),
      body: new ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 75, right: 75),
            child: new RaisedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ListPaymentPage(_dormId, _customerId, _roomId)));
              },
              textColor: Colors.white,
              color: Colors.brown[400],
              icon: Icon(Icons.remove_red_eye),
              label: Text('ประวัติใบแจ้งชำระ'),
            ),
          ),
          new Card(
            child: new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "หมายเลขห้อง : ${roomNo}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300]),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'ค่าห้องพัก ${roomPrice} บาท/เดือน',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300]),
                  ),
                ),
                new Container(
                  //padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('กรุณาเลือกเดือน : '),
                      new DropdownButton<String>(
                          value: _selectedMonth,
                          items: _month.map((String dropdownValue) {
                            return new DropdownMenuItem(
                                value: dropdownValue,
                                child: new Text(dropdownValue));
                          }).toList(),
                          onChanged: (String value) {
                            onMonthChange(value);
                          })
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: priceWater,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'ระบุค่าน้ำประปา',
                        labelText: 'ค่าน้ำประปา : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: priceElectricity,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'ระบุค่าไฟฟ้า',
                        labelText: 'ค่าไฟฟ้า : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: priceFix,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'ระบุค่าซ่อม',
                        labelText: 'ซ่อม : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: priceOther,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'ระบุอื่นๆ',
                        labelText: 'อื่น ๆ : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('รวมทั้งหมด   ${sum()}   บาท/เดือน'),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RaisedButton.icon(
                        onPressed: _selectedMonth == null ||
                                priceElectricity.text.isEmpty ||
                                priceWater.text.isEmpty
                            ? null
                            : onPaymentNotification,
                        textColor: Colors.white,
                        color: Colors.brown[400],
                        icon: Icon(Icons.save),
                        label: Text('บันทึก'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
