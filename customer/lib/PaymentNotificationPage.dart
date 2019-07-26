import 'package:flutter/material.dart';

class PaymentmultiLine extends StatefulWidget {
  int _dormId, _roomId;
  PaymentmultiLine(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentmultiLine(_dormId, _roomId);
  }
}

class _PaymentmultiLine extends State {
  int _dormId, _roomId;
  _PaymentmultiLine(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
  }
  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('ใบแจ้งชำระ'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(left: 0, right: 250, bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5)),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  ชื่อ:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  ห้อง:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  วันที่:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("  ค่าห้องพัก:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  ค่าน้ำ:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  ค่าไฟ:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  เคเบิล:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("  ซ่อม:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("  รวมทั้งหมด:"),
                  ),
                  SizedBox(
                    height: 50.0,
                    width: 90,
                  ),
                ],
              ),
            ),
          ),
          new Container(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: new RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  child: new Text('เสร็จสิ้น'),
                ),
              )),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Container(
          //       padding: EdgeInsets.only(left: 0, right: 275, bottom: 30),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.grey),
          //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //       ),
          //       child: Text("  หมายเหตุ:")),
          // ),
        ],
      ),
    );
  }
}
