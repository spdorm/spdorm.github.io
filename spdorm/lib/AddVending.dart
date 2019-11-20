import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:sweetalert/sweetalert.dart';
import 'ListTypVending.dart';

class VendingFragment extends StatefulWidget {
  int _dormId, _machineId;
  String _machineName;

  VendingFragment(int dormId, int machineId, String machineName) {
    this._dormId = dormId;
    this._machineId = machineId;
    this._machineName = machineName;
  }

  @override
  State<StatefulWidget> createState() {
    return new _VendingFragmenttState(_dormId, _machineId, _machineName);
  }
}

class _VendingFragmenttState extends State<VendingFragment> {
  int _dormId, _machineId;
  String _machineName;

  _VendingFragmenttState(int dormId, int machineId, String machineName) {
    this._dormId = dormId;
    this._machineId = machineId;
    this._machineName = machineName;
  }

  List lst = List();
  TextEditingController _machineValue = TextEditingController();

  void onMachineValue() {
    http.post('${config.API_url}/machineData/add', body: {
      "machineId": _machineId.toString(),
      "data": _machineValue.text,
    }).then((response) {
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap["status"];
      String message = jsonMap["message"];
      if (status == 0) {
        return SweetAlert.show(context,
            title: "สำเร็จ!",
            subtitle: "เพิ่มรายรับเรียบร้อยแล้ว",
            style: SweetAlertStyle.success);
        // Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext) => ListTypeVendingPage(_dormId)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
         backgroundColor: Colors.red[300],
        title: const Text('เพิ่มรายรับเครื่องหยอดเหรียญ')),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: new Row(
                    children: <Widget>[
                      new Text(' ${_machineName}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red[300])),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: TextFormField(
                    controller: _machineValue,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'ระบุยอดเงินรายรับ',
                        labelText: 'ระบุยอดเงินรายรับ: บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: RaisedButton.icon(
                      onPressed: onMachineValue,
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        'บันทึก',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.brown[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
