import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'config.dart';
import 'dart:convert';

import 'mainHomeFragment.dart';

class DataDormFragment extends StatefulWidget {
  int _dormId,_userId;
  DataDormFragment(int dormId,int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new DataDormFragmentState(_dormId,_userId);
  }
}

class DataDormFragmentState extends State<DataDormFragment> {
  int _dormId,_userId;
  DataDormFragmentState(int dormId,int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  File _image;
  bool checkImg = false;

  List<String> _status = ["active", "inactive"].toList();
  String _selectedStatus;

  String dormImage = "", _status_db;
  TextEditingController dormName = TextEditingController();
  TextEditingController dormAddress = TextEditingController();
  TextEditingController dormPhone = TextEditingController();
  TextEditingController dormEmail = TextEditingController();
  TextEditingController dormFloor = TextEditingController();
  TextEditingController dormPrice = TextEditingController();
  TextEditingController dormPromotion = TextEditingController();
  TextEditingController dormDetail = TextEditingController();

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      Map<String, dynamic> dataMap = jsonData["data"];

      if (jsonData['status'] == 0) {
        setState(() {
          dormName.text = dataMap['dormName'];
          dormAddress.text = dataMap['dormAddress'];
          dormPhone.text = dataMap['dormTelephone'];
          dormEmail.text = dataMap['dormEmail'];
          dormFloor.text = dataMap['dormFloor'];
          dormPrice.text = dataMap['dormPrice'];
          dormPromotion.text = dataMap['dormPromotion'];
          dormDetail.text = dataMap['dormDetail'];
          dormImage = dataMap['dormImage'];
          _selectedStatus = dataMap['dormStatus'];
        });
      }
    });
  }

  void onStatusChange(String item) {
    setState(() {
      _selectedStatus = item;
    });
  }

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
      checkImg = true;
    });
  }

  Future upload(File imageFile) async {
    if (imageFile != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("${config.url_upload}/upload/upload.php");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("image", stream, length,
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
    } else {
      return;
    }
  }

  void onEditDormProfile() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["dormName"] = dormName.text;
    param["dormAddress"] = dormAddress.text;
    param["dormTelephone"] = dormPhone.text;
    param["dormEmail"] = dormEmail.text;
    param["dormFloor"] = dormFloor.text;
    param["dormPrice"] = dormPrice.text;
    param["dormPromotion"] = dormPromotion.text;
    param["dormDetail"] = dormDetail.text;
    param["dormStatus"] = _selectedStatus.toString();

    http
        .post('${config.API_url}/dorm/updateDormProfile', body: param)
        .then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData['status'] == 0) {
        upload(_image).then((_) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('ข้อมูลหอพัก'),
        leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId))); },
      );
    },
  ),
      ),
      resizeToAvoidBottomPadding: false,
      body: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          Text(':รายละเอียดข้อมูลหอพัก'),
          new Card(
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.image),
                      new Text('Drom picture:'),
                    ],
                  ),
                ),
                dormImage == null || checkImg == true || dormImage == ""
                    ? new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: _image == null
                            ? Text('No image selected.')
                            : Image.file(_image),
                      )
                    : Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          child: Image.network(
                              '${config.url_upload}/upload/image/dorm/${dormImage}'),
                        ),
                      ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: FloatingActionButton(
                    onPressed: getImageGallery,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("สถานะ :"),
                    ),
                    new DropdownButton<String>(
                        value: _selectedStatus,
                        items: _status.map((String value) {
                          return new DropdownMenuItem(
                              value: value, child: new Text(value));
                        }).toList(),
                        onChanged: (String value) {
                          onStatusChange(value);
                        }),
                  ],
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: dormName,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.home),
                        hintText: 'Enter a dorm name',
                        labelText: 'Dorm name:',
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
                        hintText: 'Enter a email address',
                        labelText: 'Address:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: dormPhone,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.phone_android),
                        hintText: 'Enter a Telephone',
                        labelText: 'Tel:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: dormEmail,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.email),
                        hintText: 'Enter a Email',
                        labelText: 'Email:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: dormFloor,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.add_circle),
                        hintText: 'Number of Floor',
                        labelText: 'Number of Floor:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: dormPrice,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.attach_money),
                        hintText: 'Enter a Room price',
                        labelText: 'Room price:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.content_paste),
                      new Text('Promotion:'),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextField(
                    controller: dormPromotion,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Please Type Your Text then click submit',
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.star_half),
                      new Text('details:'),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextField(
                    controller: dormDetail,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Please Type Your Text then click submit',
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: new RaisedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('คุณต้องการแก้ไขข้อมูลหอพัก ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ยืนยัน'),
                                      onPressed: onEditDormProfile,
                                    ),
                                    FlatButton(
                                      child: Text('ยกเลิก'),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                  ],
                                ));
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
