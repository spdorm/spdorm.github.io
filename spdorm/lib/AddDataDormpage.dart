import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sweetalert/sweetalert.dart';
import 'AddDormpage.dart';
import 'config.dart';
import 'dart:convert';

// import 'multiImagePicker.dart';

class RegisterDataDorm extends StatefulWidget {
  int _userId;
  RegisterDataDorm(int userId) {
    this._userId = userId;
    print(_userId);
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterDataDorm(_userId);
  }
}

class _RegisterDataDorm extends State {
  int _userId, _dormId;
  _RegisterDataDorm(int userId) {
    this._userId = userId;
  }

  File _image;
  List<Asset> _images = List<Asset>();
  bool _errorName = false, _errorFloor = false;

  @override
  void initState() {
    _errorName = false;
    _errorFloor = false;

    // if (_images.isEmpty) {
    //   _images = null;
    // }
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
          statusBarColor: "#e57373",
          actionBarColor: "#e57373",
          actionBarTitle: "เลือกรูปหอพัก",
          allViewTitle: "รูปทั้งหมด",
          useDetailsView: true,
          selectCircleStrokeColor: "#f5f6fa",
        ),
      );
    } catch (e) {}

    if (!mounted) return;

    setState(() {
      if (resultList != null) {
        _images = resultList;
      }
    });
  }

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    setState(() {
      _image = imageFile;
    });
  }

  Future upload(File imageFile) async {
    if (imageFile != null) {
      SweetAlert.show(
        context,
        subtitle: "กำลังสร้างรายการหอพัก...",
        style: SweetAlertStyle.loading,
      );
      var stream = new http.ByteStream(
        DelegatingStream.typed(
          imageFile.openRead(),
        ),
      );
      var length = await imageFile.length();
      var uri = Uri.parse("${config.API_url}/dorm/saveImage");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: path.basename(imageFile.path));
      request.fields['dormId'] = _dormId.toString();
      request.files.add(multipartFile);
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  Future<void> uploadsImages() async {
    var uri = Uri.parse('${config.API_url}/imageDetail/saveImage');

    if (_images.isNotEmpty && _images.length > 0) {
      SweetAlert.show(
        context,
        subtitle: "กำลังเพิ่มรูปภาพหอพัก...",
        style: SweetAlertStyle.loading,
      );
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
        request.fields['dormId'] = _dormId.toString();
        request.fields['index'] = '$i';
        var response = await request.send();
        print(response.statusCode);
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      }
    }
  }

  TextEditingController dormName = TextEditingController();
  TextEditingController dormAddress = TextEditingController();
  TextEditingController dormTelephone = TextEditingController();
  TextEditingController dormEmail = TextEditingController();
  TextEditingController dormFloor = TextEditingController();

  void onRegisterDataDorm() {
    Map<String, dynamic> param = Map();
    param["dormName"] = dormName.text;
    param["dormAddress"] = dormAddress.text;
    param["dormTelephone"] = dormTelephone.text;
    param["dormEmail"] = dormEmail.text;
    param["dormFloor"] = dormFloor.text;
    param["userId"] = _userId.toString();
    param["dormStatus"] = 'active';

    if (dormName.text.isNotEmpty && dormFloor.text.isNotEmpty) {
      _errorName = false;
      _errorFloor = false;
      http.post('${config.API_url}/dorm/add', body: param).then((response) {
        print(response.body);
        Map jsonMap = jsonDecode(response.body) as Map;
        int status = jsonMap["status"];
        _dormId = jsonMap["data"];

        if (status == 0) {
          upload(_image).then((_) {
            uploadsImages().then((_) {
              SweetAlert.show(context,
                  title: "สำเร็จ",
                  subtitle: "สร้างหอพักเรียบร้อยแล้ว",
                  style: SweetAlertStyle.success, onPress: (bool check) {
                if (check) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddDormPage(_userId)));
                }
                return false;
              });
            });
          });
        }
      });
    } else if (dormName.text.isEmpty && dormFloor.text.isNotEmpty) {
      setState(() {
        _errorName = true;
        _errorFloor = false;
      });
    } else if (dormFloor.text.isEmpty && dormName.text.isNotEmpty) {
      setState(() {
        _errorName = false;
        _errorFloor = true;
      });
    } else {
      setState(() {
        _errorName = true;
        _errorFloor = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          backgroundColor: Colors.red[300], title: const Text('เพิ่มหอพัก')),
      body: new ListView(
        shrinkWrap: true,
        //padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormName,
              decoration: InputDecoration(
                icon: const Icon(Icons.home),
                hintText: 'ระบุชื่อหอพัก',
                labelText: 'ชื่อหอพัก',
                labelStyle: TextStyle(fontSize: 15),
                errorText: _errorName ? "กรุณากรอกข้อมูล" : null,
                errorStyle: TextStyle(color: Colors.red),
                focusedErrorBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormAddress,
              decoration: InputDecoration(
                  icon: const Icon(Icons.add_location),
                  hintText: 'ระบุที่อยู่หอพัก',
                  labelText: 'ที่อยู่',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormTelephone,
              decoration: InputDecoration(
                  icon: const Icon(Icons.local_phone),
                  hintText: 'ระบุหมายเลขโทรศัพท์',
                  labelText: 'หมายเลขโทรศัพท์',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.phone,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormEmail,
              decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'ระบุอีเมล',
                  labelText: 'อีเมล',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormFloor,
              decoration: InputDecoration(
                icon: const Icon(Icons.library_add),
                hintText: 'ระบุจำนวนชั้น',
                labelText: 'จำนวนชั้น',
                labelStyle: TextStyle(fontSize: 15),
                errorText: _errorFloor ? "กรุณากรอกข้อมูล" : null,
                errorStyle: TextStyle(color: Colors.red),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Text('รูปปกหอพัก'),
              ],
            ),
          ),
          new Center(
            child: _image == null
                ? Text('โปรดเลือกรูปภาพปกหอพัก')
                : Image.file(_image),
          ),
          new Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: FloatingActionButton(
              heroTag: "bt1",
              onPressed: getImageGallery,
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.brown[400],
            ),
          ),
          new Divider(
            color: Colors.grey,
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Text('รูปหอพักเพิ่มเติม'),
              ],
            ),
          ),
          _images.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(0),
                )
              : Column(
                  children: <Widget>[
                    GridView.count(
                      physics: ScrollPhysics(),
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
          new Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: FloatingActionButton(
              heroTag: "bt2",
              onPressed: loadAssets,
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.brown[400],
            ),
          ),
          new Divider(
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Center(
              child: new RaisedButton(
                onPressed: onRegisterDataDorm,
                textColor: Colors.white,
                color: Colors.brown[400],
                child: new Text('เพิ่มหอพัก'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
