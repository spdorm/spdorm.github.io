import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:sweetalert/sweetalert.dart';
import 'AddDormpage.dart';
import 'config.dart';
import 'dart:convert';

class RegisterDataDorm extends StatefulWidget {
  int _userId;
  RegisterDataDorm(int userId) {
    this._userId = userId;
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

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = imageFile;
    });
  }

  Future upload(File imageFile) async {
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังสร้างรายการหอพัก...", style: SweetAlertStyle.loading);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
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

  TextEditingController dormName = TextEditingController();
  TextEditingController dormAddress = TextEditingController();
  TextEditingController dormTelephone = TextEditingController();
  TextEditingController dormEmail = TextEditingController();
  TextEditingController dormFloor = TextEditingController();
//  TextEditingController dormImage = TextEditingController();

  void onRegisterDataDorm() {
    Map<String, dynamic> param = Map();
    param["dormName"] = dormName.text;
    param["dormAddress"] = dormAddress.text;
    param["dormTelephone"] = dormTelephone.text;
    param["dormEmail"] = dormEmail.text;
    param["dormFloor"] = dormFloor.text;
//  param["dormImage"] = dormImage.text;
    param["userId"] = _userId.toString();
    param["dormStatus"] = 'active';

    http.post('${config.API_url}/dorm/add', body: param).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap["status"];
      String message = jsonMap["message"];
      setState(() {
        _dormId = jsonMap["data"];
      });
      if (status == 0) {
        upload(_image).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddDormPage(_userId)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(title: const Text('เพิ่มข้อมูลหอพัก')),
      body: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.date_range),
                new Text('ข้อมูลหอพัก'),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormName,
              decoration: InputDecoration(
                  icon: const Icon(Icons.home),
                  hintText: 'กรอกชื่อหอพัก',
                  labelText: 'ชื่อหอพัก:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormAddress,
              decoration: InputDecoration(
                  icon: const Icon(Icons.add_location),
                  hintText: 'กรอกที่อยู่หอพัก',
                  labelText: 'ที่อยู่:',
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
                  hintText: 'กรอกเบอร์โทร',
                  labelText: 'เบอร์โทร:',
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
                  hintText: 'กรอกอีเมล์',
                  labelText: 'อีเมล์:',
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
                  hintText: 'กรอกจำนวนชั้น',
                  labelText: 'จำนวนชั้น:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.number,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.image),
                new Text('รูปหอพัก:'),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child:
                _image == null ? Text('ไม่มีรูปที่เลือก') : Image.file(_image),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: FloatingActionButton(
              onPressed: getImageGallery,
              tooltip: 'เลือกรูปหอพัก',
              child: Icon(Icons.add_a_photo),
            ),
          ),
          Container(
            child: Center(
              child: new RaisedButton(
                onPressed: onRegisterDataDorm,
                textColor: Colors.white,
                color: Colors.blue,
                child: new Text('บันทึก'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
