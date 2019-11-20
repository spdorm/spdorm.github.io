import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'listStatusInform.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sweetalert/sweetalert.dart';

class InformMultiLine extends StatefulWidget {
  int _dormId, _userId, _roomId;
  String _userName;
  InformMultiLine(int dormId, int userId, int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
  }

  @override
  State<StatefulWidget> createState() {
    return new InformMultiLineState(_dormId, _userId, _roomId, _userName);
  }
}

class InformMultiLineState extends State<InformMultiLine> {
  int _dormId, _userId, _roomId;
  String _userName;
  InformMultiLineState(int dormId, int userId, int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
  }

  List<Asset> _images = List<Asset>();
  bool _errorName = false, _errorFloor = false;

  @override
  void initState() {
    _errorName = false;
    _errorFloor = false;
    if (_images.isEmpty) {
      _images = null;
    }
    super.initState();
  }

  Future<void> loadAssets() async {
    setState(() {
      _images = List<Asset>();
    });
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        materialOptions: MaterialOptions(
          statusBarColor: "#64B5F6",
          actionBarColor: "#64B5F6",
          actionBarTitle: "เลือกรูปแจ้งซ่อม",
          allViewTitle: "รูปทั้งหมด",
          useDetailsView: true,
          selectCircleStrokeColor: "#f5f6fa",
        ),
      );
    } catch (e) {}

    if (!mounted) return;

    setState(() {
      _images = resultList;
    });
  }

  Future<bool> uploadsImages(int _fixId) async {
    var uri = Uri.parse('${config.API_url}/fixImages/saveImage');
    int count = 0, index = 0;
    if (_images.isNotEmpty || _images.length > 0) {
      SweetAlert.show(context,
          subtitle: "กำลังเพิ่มรูปภาพแจ้งซ่อม...", style: SweetAlertStyle.loading);
      for (int i = 0; i < _images.length; i++) {
        var request = http.MultipartRequest('POST', uri);
        ByteData byteData = await _images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'file',
          imageData,
          filename: '${_images[i].name}',
        );
        request.files.add(multipartFile);
        request.fields['fixId'] = _fixId.toString();
        request.fields['index'] = '$i';
        var response = await request.send();

        if (response.statusCode == 200) {
          count++;
          index = i;
        }

        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      }
    }
    if (count == (index + 1)) {
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();

  TextEditingController fixTopic = TextEditingController();
  TextEditingController fixDetail = TextEditingController();

  void onfixDorm() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = '${_userId}';
    param["roomId"] = _roomId.toString();
    param["roomNo"] = _roomId.toString();
    param["fixTopic"] = fixTopic.text;
    param["fixDetail"] = fixDetail.text;
    param["fixStatus"] = 'active';
    http.post('${config.API_url}/fix/add', body: param).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      int fixId = jsonMap['data'];
      if (status == 0) {
        print(fixId);
        uploadsImages(fixId).then((check) {
          print(check);
          if (check) {
            return SweetAlert.show(context,
                title: "สำเร็จ!",
                subtitle: "แจ้งซ่อมเรียบร้อยแล้ว",
                style: SweetAlertStyle.success);
          } else {
            return SweetAlert.show(context,
                title: "ไม่สำเร็จ!",
                subtitle: "กรุณาแจ้งซ่อมใหม่อีกครั้ง ",
                style: SweetAlertStyle.error);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('การแจ้งซ่อม'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding:EdgeInsets.only(top: 8.0),
                child: Center(
                  child: new RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext) => listStatusInformPage(
                                  _dormId, _userId, _roomId, _userName)));
                    },
                    textColor: Colors.white,
                    color: Colors.blueGrey[400],
                    child: new Text('ตรวจสอบสถานะรายการ'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: fixTopic,
                        decoration: InputDecoration(
                          hintText: 'หัวข้อการแจ้งซ่อม :',
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              new Divider(
                color: Colors.grey,
              ),
              new Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: new Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: new Text('** กรุณาเพิ่มรูปภาพประกอบการแจ้งซ่อม **'),
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 8),
                      child: FloatingActionButton(
                        onPressed: loadAssets,
                        child: Icon(Icons.add_a_photo),
                        backgroundColor: Colors.blueGrey[200],
                      ),
                    ),
                  ],
                ),
              ),
              _images == null
                  ? Padding(
                      padding: EdgeInsets.all(0),
                    )
                  : Column(
                      children: <Widget>[
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: List.generate(_images.length, (index) {
                            Asset asset = _images[index];
                            return AssetThumb(
                              asset: asset,
                              width: 1024,
                              height: 768,
                            );
                          }),
                        )
                      ],
                    ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: fixDetail,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'หมายเหตุ :',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FlatButton(
                        onPressed: onfixDorm,
                        child: const Text('ตกลง'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
