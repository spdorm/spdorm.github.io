import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'config.dart';
import 'dart:convert';

class CharterDormFragment extends StatefulWidget {
  int _roomId;
  String _roomNo;
  CharterDormFragment(int roomId,String roomNo){
    this._roomNo = roomNo;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new CharterDormFragmentState(_roomId,_roomNo);
  }
}

class CharterDormFragmentState extends State<CharterDormFragment> {
  int _roomId;
  String _roomNo;
  CharterDormFragmentState(int roomId,String roomNo) {
    this._roomNo = roomNo;
    this._roomId = roomId;
    print(_roomId);
  }

  File _image, _see;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 1024,maxHeight: 1024);
    lst.clear();
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
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("${config.url_upload}/upload/upload_charter.php");

    var request = new http.MultipartRequest("POST", uri);
    print(path.basename(imageFile.path));
    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: path.basename(imageFile.path));
    request.fields['roomId'] = _roomId.toString();
    request.fields['roomNo'] = _roomNo.toString();
    request.fields['username'] = userName.text;
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

  TextEditingController roomNo = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController roomDocument = TextEditingController();
  String massege = "";
  Color color;

  Future alartDialog(String str){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('คุณต้องการออกจากระบบ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ไม่ใช่'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('ใช่'),
                  onPressed: () => {
                        
                      },
                ),
              ],
            ),
            );
  }

  void onDataDorm() {
    Map<String, dynamic> param = Map();
    param["roomId"] = _roomId.toString();
    param["userName"] = userName.text;

    http
        .post('${config.API_url}/room/updateCustomerToRoom', body: param)
        .then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        upload(_image).then((_) {
          massege = jsonMap['message'];
          color = Colors.green;
          setState(() {});
          Navigator.pop(context);
        });
      } else {
        massege = "ไม่พบบัญชีผู้ใช้นี้";
        color = Colors.red;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new ListView(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          children: <Widget>[
            Text(':รายละเอียดข้อมูลสัญญาเช่า'),
            new Card(
              margin: EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Text('หมายเลขห้อง : ${_roomNo}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      controller: userName,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a Customer name',
                          labelText: 'ชื่อลูกค้า:',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                    '${massege}',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.image),
                        new Text('ใบสัญญาเช่า:'),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(_image),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: FloatingActionButton(
                      onPressed: getImageGallery,
                      tooltip: 'Pick Image',
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 70, top: 5, right: 1),
                        child: new RaisedButton(
                          onPressed: onDataDorm,
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: new Row(
                            children: <Widget>[
                              new Text('บันทึก'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1, top: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.blueGrey,
                          child: new Row(
                            children: <Widget>[
                              new Text('แก้ไข'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}
