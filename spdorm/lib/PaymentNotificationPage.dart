import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'listPayment.dart';

class PaymentmultiLine extends StatefulWidget {
  int _dormId, _userId, _roomId;
  String _date, _dateShow;
  PaymentmultiLine(
      int dormId, int userId, int roomId, String date, String dateShow) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
    this._date = date;
    this._dateShow = dateShow;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentmultiLine(_dormId, _userId, _roomId, _date, _dateShow);
  }
}

class _PaymentmultiLine extends State {
  int _dormId, _userId, _roomId;
  String _date, _dateShow;
  _PaymentmultiLine(
      int dormId, int userId, int roomId, String date, String dateShow) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
    this._date = date;
    this._dateShow = dateShow;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  List<String> _Status = ["จ่ายแล้ว", "ยังไม่จ่าย"].toList();
  String _selectedStatus;
  String _name, _roomNo, _price;
  Color color;
  int _invoiceId;
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
    http.post('${config.API_url}/invoice/list', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      Map jsonData = jsonDecode(response.body) as Map;
      List temp = jsonData['data'];
      if (jsonData['status'] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List dataPay = temp[i];

          if (_date == dataPay[1]) {
            if (dataPay[3] == "ยังไม่จ่าย") {
              color = Colors.red;
              _selectedStatus = _Status[1];
            } else {
              color = Colors.green;
              _selectedStatus = _Status.first;
            }
            _invoiceId = dataPay[0];
            _name = dataPay[13] + "  " + dataPay[14];
            _body(dataPay);
            _bodyChangeStatus();
          }
        }
      }
    });
  }

  void _body(List dataPay) {
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
                child: Text('ชื่อ : ${_name}'),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('ห้อง : ${dataPay[12]}'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('วันที่ : ${_dateShow}'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าห้องพัก : ${dataPay[11]}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าน้ำ : ${dataPay[9]}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าไฟฟ้า : ${dataPay[4]} บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าซ่อม : ${dataPay[5]}  บาท'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('ค่าอื่น ๆ : ${dataPay[7]}  บาท'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text('รวมทั้งหมด : ${dataPay[8]}  บาท'),
              ),
            ],
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
                  '${dataPay[3]}',
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
            child: Text("แก้ไขสถานะ :"),
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

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ใบแจ้งชำระ'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ListPaymentPage(_dormId, _userId, _roomId)));
              },
            ),
          ),
          body: ListView.builder(
            itemBuilder: bodyBuild,
            itemCount: lst.length,
          )),
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ListPaymentPage(_dormId, _userId, _roomId)));
      },
    );
  }
}
