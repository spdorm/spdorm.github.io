import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spdorm/ConvertDateTime.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'mainHomeFragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentNotiCheckOutPage extends StatefulWidget {
  int _invoiceId;
  String _fullName;
  PaymentNotiCheckOutPage(int invoiceId, String fullName) {
    this._invoiceId = invoiceId;
    this._fullName = fullName;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentNotiCheckOutPage(_invoiceId, _fullName);
  }
}

class _PaymentNotiCheckOutPage extends State {
  int _invoiceId;
  String _fullName;
  _PaymentNotiCheckOutPage(int invoiceId, String fullName) {
    this._invoiceId = invoiceId;
    this._fullName = fullName;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  List<String> _Status = ["จ่ายแล้ว", "ยังไม่จ่าย"].toList();
  String _selectedStatus;
  String _name, _roomNo, _price, _date, _roomId;
  Color color;
  int _pledge = 0, _sum = 0;
  List lst = new List();

  void onStatusChange(String item) {
    _selectedStatus = item;
    if (_selectedStatus == "จ่ายแล้ว") {
      onSumit("จ่ายแล้ว");
    } else {
      onSumit("ยังไม่จ่าย");
    }
  }

  void onSumit(String status) {
    http.post('${config.API_url}/invoice/updateStatus', body: {
      "invoiceId": _invoiceId.toString(),
      "status": status,
    }).then((respone) {
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        lst.clear();
        _conApi();
        return SweetAlert.show(context,
            subtitle: "สำเร็จ!", style: SweetAlertStyle.success);
      }
    });
  }

  @override
  void initState() {
    _conApi();
    super.initState();
  }

  void _conApi() {
    http.post('${config.API_url}/invoice/findByInvoiceId', body: {
      "invoiceId": _invoiceId.toString(),
    }).then((response) {
      // print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;

      if (jsonData['status'] == 0) {
        Map<String, dynamic> data = jsonData['data'];
        _roomId = data['roomId'].toString();
        http.post('${config.API_url}/room/listRoom', body: {
          "dormId": data['dormId'].toString(),
          "roomId": data['roomId'].toString()
        }).then((respone) {
          // print(respone.body);
          Map jsonData = jsonDecode(respone.body) as Map;

          if (jsonData["status"] == 0) {
            Map<String, dynamic> listData = jsonData["data"];
            convertDateTime objDateToThai = convertDateTime();

            _date = objDateToThai.convertToThai(data['dateTime']);
            _pledge = int.parse(listData['pledge']);
            _roomNo = listData['roomNo'];
            _price = listData['roomPrice'];

            if (data['invoiceStatus'] == "ยังไม่จ่าย") {
              color = Colors.red;
              _selectedStatus = _Status[1];
            } else {
              color = Colors.green;
              _selectedStatus = _Status.first;
            }
            // _name = dataPay[13] + "  " + dataPay[14];
            _body(data, _pledge, _roomNo, _price);
            _bodyChangeStatus();
            _buttonCheckOut();
          }
        });
      }
    });
  }

  Future<int> _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  void _onPressed() {
    return SweetAlert.show(context,
        subtitle: "คุณต้องการยกเลิกสัญญาเช่า ?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        SweetAlert.show(context,
            subtitle: "กำลังลบ...", style: SweetAlertStyle.loading);
        new Future.delayed(new Duration(seconds: 1), () {
          http.post('${config.API_url}/room/cancelRent',
              body: {"roomId": _roomId.toString()}).then((response) {
            print(response.body);
            Map jsonData = jsonDecode(response.body) as Map;
            if (jsonData["status"] == 0) {
              _getId().then((int userId) {
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext) =>
                //             MainHomeFragment(_dormId, userId,)));
                SweetAlert.show(context,
                    subtitle: "สำเร็จ!",
                    style: SweetAlertStyle.success, onPress: (bool isConfirm) {
                  if (isConfirm) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext) =>
                    //             MainHomeFragment(_dormId, userId)));
                  }
                  return false;
                });
              });
            }
          });
        });
      } else {
        SweetAlert.show(context,
            subtitle: "ยกเลิก!", style: SweetAlertStyle.error);
      }
      // return false to keep dialog
      return false;
    });
  }

  void _body(Map<String, dynamic> dataPay, int pledge, String roomNo,
      String roomPrice) {
    Container detil = Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text('ชื่อ : ${_fullName}'),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('ห้อง : ${_roomNo}'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('วันที่ : ${_date}'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าห้องพัก : ${roomPrice}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าน้ำประปา : ${dataPay['priceWater']}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าไฟฟ้า : ${dataPay['priceElectricity']} บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าซ่อม : ${dataPay['priceFix']}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าทำความสะอาด : ${dataPay['priceOther']}  บาท'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text('รวมทั้งหมด : ${dataPay['priceTotal']}  บาท'),
              ),
            ],
          ),
          Center(
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(5),
                  child: Text('ค่าประกัน : ${_pledge} บาท'),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    "คืนค่าประกันทั้งหมด : ${pledge - int.parse(dataPay['priceTotal'])} บาท",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300]),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'สถานะ :',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  '${dataPay['invoiceStatus']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    setState(() {
      lst.add(detil);
    });
  }

  void _bodyChangeStatus() {
    Card _cardChang = Card(
      margin: EdgeInsets.only(left: 8, right: 8, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(5),
            child: Text("แก้ไขสถานะ : "),
          ),
          new DropdownButton<String>(
              value: _selectedStatus,
              items: _Status.map((String dropdownStatusValue) {
                return new DropdownMenuItem(
                    value: dropdownStatusValue,
                    child: new Text(
                      dropdownStatusValue,
                      style: TextStyle(color: Colors.black54),
                    ));
              }).toList(),
              onChanged: (String value) {
                onStatusChange(value);
              }),
        ],
      ),
    );
    setState(() {
      lst.add(_cardChang);
    });
  }

  void _buttonCheckOut() {
    Column _button = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: RaisedButton(
            child: Text(
              'ยกเลิกสัญญาเช่า',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _selectedStatus == "จ่ายแล้ว" ? _onPressed : null ,
            color: Colors.red[400],
          ),
        )
      ],
    );
    setState(() {
      lst.add(_button);
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.red[300],
            title: Text('ใบแจ้งชำระ'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             ListPaymentCheckOutPage(
                //                 _dormId, _userId, _roomId)));
              },
            ),
          ),
          body: ListView.builder(
            itemBuilder: bodyBuild,
            itemCount: lst.length,
          )),
      onWillPop: () {
        Navigator.pop(context);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) =>
        //             ListPaymentPage(_dormId, _userId, _roomId)));
      },
    );
  }
}