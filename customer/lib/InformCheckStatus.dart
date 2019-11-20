import 'package:customer/ConvertDateTime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class InformCheckStatusPage extends StatefulWidget {
  int _dormId, _fixId;
  String _userName, _roomNo;
  InformCheckStatusPage(int dormId, String userName, String roomNo, int fixId) {
    this._dormId = dormId;
    this._userName = userName;
    this._roomNo = roomNo;
    this._fixId = fixId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _InformCheckStatusPage(_dormId, _userName, _roomNo, _fixId);
  }
}

class _InformCheckStatusPage extends State<InformCheckStatusPage> {
  int _dormId, _fixId;
  String _userName, _roomNo;
  _InformCheckStatusPage(
      int dormId, String userName, String roomNo, int fixId) {
    this._dormId = dormId;
    this._userName = userName;
    this._roomNo = roomNo;
    this._fixId = fixId;
  }
  //TextEditingController _roomNo = TextEditingController();
  //TextEditingController _roomPrice = TextEditingController();
  var _image;

  String dropdownStatusValue;
  String dropdownValue;

  List<String> _Status = ["รอดำเนินการ", "ดำเนินการแล้ว"].toList();

  // String _selectedStatus = null;
  List images = List();
  String _selectedStatus;
  String _date, _detail,_fixNote;
  int _fixPrice =0;
  Color color;
  List lst = List();

  @override
  void initState() {
    super.initState();
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) async {
      // print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0 && jsonData["data"].isNotEmpty) {
        Map<String, dynamic> data = temp[0];
        convertDateTime objDateTime = convertDateTime();
        _date = objDateTime.convertToThai(data['dateTime']);

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
          // _date = data['dateTime'].toString().substring(8, 10) +
          //     data['dateTime'].toString().substring(4, 7) +
          //     "-" +
          //     data['dateTime'].toString().substring(0, 4);
          _detail = data['fixDetail'];
          _fixPrice = data['fixPrice'];
          _fixNote = data['fixNote'];

          if (data['fixStatus'] == "active") {
            _selectedStatus = _Status.first;
            color = Colors.red;
          } else if (data['fixStatus'] == "success") {
            _selectedStatus = _Status[1];
            color = Colors.green;
          }

          _body();
        });
      }
    });
  }

  void _body() {
    Card body = Card(
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                child: Text("ผู้เช่า :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 20.0),
                    child: Text(
                      '${_userName}',
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                child: Text("ห้อง :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 20.0),
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
                padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                child: Text("วันที่ :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 20.0),
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
                padding:
                    EdgeInsets.only(left: 20, right: 5, bottom: 20, top: 20),
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
          Row(
            children: <Widget>[
              new Container(
                padding:
                    EdgeInsets.only(left: 20, right: 5, bottom: 20, top: 20),
                child: Text("ภาพประกอบการแจ้งซ่อม :"),
              ),
            ],
          ),
          images.isNotEmpty && images != null
              ? GridView.count(
                  physics: ScrollPhysics(),
                  // padding: EdgeInsets.all(5),
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
                  padding: EdgeInsets.all(0),
                ),
        ],
      ),
    );
    lst.add(body);

    Container status = Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'สถานะ : ',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                ' ${_selectedStatus}',
                style: TextStyle(fontSize: 16, color: color),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ค่าใช้จ่าย : ',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                ' ${_fixPrice}',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );

    Container note = Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 5, bottom: 20, top: 20),
                  child: Text("หมายเหตุ :"),
                ),
                Container(
                  //padding: EdgeInsets.only(right: 10, top: 20.0),
                  child: Expanded(
                    child: Text(
                      '${_fixNote}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    lst.add(status);
    lst.add(note);
    setState(() {});
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
          backgroundColor: Colors.blue[300],
          title: Text('การแจ้งซ่อม'),
        ),
        body: new ListView.builder(
          padding: EdgeInsets.all(8),
          itemBuilder: bodyBuild,
          itemCount: lst.length,
        ));
  }
}
