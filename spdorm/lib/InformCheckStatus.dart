import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spdorm/ConvertDateTime.dart';
import 'package:sweetalert/sweetalert.dart';
import 'InfromAlert.dart';
import 'config.dart';
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class InformCheckStatusPage extends StatefulWidget {
  int _dormId, _userId, _fixId;
  String _userName, _roomNo;
  InformCheckStatusPage(
      int dormId, int userId, String userName, String roomNo, int fixId) {
    this._dormId = dormId;
    this._userId = userId;
    this._userName = userName;
    this._roomNo = roomNo;
    this._fixId = fixId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _InformCheckStatusPage(
        _dormId, _userId, _userName, _roomNo, _fixId);
  }
}

class _InformCheckStatusPage extends State<InformCheckStatusPage> {
  int _dormId, _userId, _fixId;
  String _userName, _roomNo;
  _InformCheckStatusPage(
      int dormId, int userId, String userName, String roomNo, int fixId) {
    this._dormId = dormId;
    this._userId = userId;
    this._userName = userName;
    this._roomNo = roomNo;
    this._fixId = fixId;
  }

  TextEditingController _fixPrice = TextEditingController();
  TextEditingController _fixNote = TextEditingController();

  var _image;

  String dropdownStatusValue;
  String dropdownValue;

  List<String> _Status =
      ["รอดำเนินการ", "กำลังดำเนินการ", "ดำเนินการเสร็จแล้ว"].toList();

  List images = List();

  // String _selectedStatus = null;
  String _selectedStatus;
  String _date, _detail;
  List lst = new List();

  @override
  void initState() {
    super.initState();
    _conApi();
  }

  void onSumit() {
    String status;
    if (_selectedStatus == "รอดำเนินการ") {
      status = "wait";
    } else if (_selectedStatus == "กำลังดำเนินการ") {
      status = "active";
    } else {
      status = "success";
    }

    http.post('${config.API_url}/fix/updateStatus',
        body: {"fixId": _fixId.toString(), "status": status}).then((respone) {
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        lst.clear();
        _conApi();
        SweetAlert.show(context,
            subtitle: "สำเร็จ!",
            style: SweetAlertStyle.success, onPress: (bool isTrue) {
          if (isTrue) {
            Navigator.pop(context);
            return false;
          }
        });
      }
    });
  }

  void onStatusChange(String item) {
    _selectedStatus = item;
    onSumit();
  }

  void _conApi() {
    http.post('${config.API_url}/fix/findByFixId',
        body: {"fixId": _fixId.toString()}).then((response) async {
      print(response.body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData["status"] == 0) {
        Map<String, dynamic> data = jsonData['data'];

        if (data['fixPrice'].toString().isNotEmpty) {
          _fixPrice.text = data['fixPrice'].toString();
        }
        if (data['fixNote'].toString().isNotEmpty) {
          _fixNote.text = data['fixNote'];
        }

        convertDateTime objDateToThai = convertDateTime();

        var res_nameImages = await http.post(
            '${config.API_url}/fixImages/getNameImages',
            body: {"fixId": _fixId.toString()});

        Map jsonDataName = jsonDecode(res_nameImages.body);

        if (jsonDataName['status'] == 0) {
          List temp = jsonDataName['data'];
          for (int i = 0; i < temp.length; i++) {
            Map<String, dynamic> dataName = temp[i];
            images.add(dataName['imageName']);
          }
        }

        setState(() {
          _fixId = data['fixId'];
          _date = objDateToThai.convertToThai(data['dateTime']);
          _detail = data['fixDetail'];
          // _selectedStatus = data['fixStatus'];
          if (data['fixStatus'] == "wait") {
            _selectedStatus = _Status[0];
          } else if (data['fixStatus'] == "active") {
            _selectedStatus = _Status[1];
          } else {
            _selectedStatus = _Status[2];
          }
        });
        _body();
      }
    });
  }

  void onFixProceed() {
    Map<String, dynamic> param = Map();
    param["fixId"] = _fixId.toString();
    param["fixPrice"] = _fixPrice.text.isEmpty ? '0' : _fixPrice.text;
    param["fixNote"] = _fixNote.text;
    http
        .post('${config.API_url}/fix/updateFixNoteAndFixPrice', body: param)
        .then((response) {
       print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        SweetAlert.show(context,
            title: "สำเร็จ!",
            subtitle: "ดำเนินการแจ้งซ่อมเรียบร้อยแล้ว",
            style: SweetAlertStyle.success);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    InformAlertPage(_dormId, _userId)));
      }
    });
  }

  void _body() {
    Container head = Container(
      padding: EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Text(' รายละเอียดการแจ้งซ่อม'),
        ],
      ),
    );

    Card body = Card(
      margin: EdgeInsets.all(0.5),
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: <Widget>[
                new Container(
                  child: Text("ผู้เช่า :"),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '${_userName}',
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
                child: Text("ห้อง :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10.0),
                    child: Text(
                      '${_roomNo}',
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
                child: Text("วันที่ :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10.0),
                    child: Text(
                      '${_date}',
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 10),
                child: Text("รายละเอียดรายการ :"),
              ),
              Container(
                //padding: EdgeInsets.only(right: 10, top: 20.0),
                child: Expanded(
                  child: Text(
                    '${_detail}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            children: <Widget>[
              new Container(
                padding:
                    EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
                child: Text("ภาพประกอบการแจ้งซ่อม :"),
              ),
            ],
          ),
          images.isNotEmpty && images != null
              ? GridView.count(
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  children: <Widget>[
                    PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(
                              '${config.API_url}/fixImages/image?nameImage=${images[index]}'),
                          initialScale: PhotoViewComputedScale.contained * 0.8,
                        );
                      },
                      itemCount: images.length,
                    )
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                ),
          Divider(
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
                child: Text("สถานะ :"),
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
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              // readOnly: _fixPrice.text.isEmpty ? false : true,
              controller: _fixPrice,
              decoration: InputDecoration(
                  icon: const Icon(
                    Icons.attach_money,
                    color: Colors.purple,
                  ),
                  hintText: '** คลิกเพื่อเพิ่มค่าใช้จ่าย',
                  labelText: 'ค่าใช้จ่าย:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Icon(
                  Icons.content_paste,
                  color: Colors.yellow[700],
                ),
                new Text(
                  ' หมายเหตุ:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: TextField(
              controller: _fixNote,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '** คลิกเพื่อเพิ่มหมายเหตุ **',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: onFixProceed,
                textColor: Colors.white,
                color: Colors.brown[400],
                child: new Row(
                  children: <Widget>[
                    new Text('บันทึก'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
    setState(() {
      lst.add(head);
      lst.add(body);
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('การแจ้งซ่อม'),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
