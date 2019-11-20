import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'AddDataDormpage.dart';

class multiImagePicker extends StatefulWidget {
  int _userId;
  multiImagePicker(int userId) {
    this._userId = userId;
  }
  @override
  _multiImagePickerState createState() => _multiImagePickerState(_userId);
}

class _multiImagePickerState extends State<multiImagePicker> {
  int _userId;
  _multiImagePickerState(int userId) {
    this._userId = userId;
  }

  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    if (images.isEmpty) {
      images = null;
    }
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 1024,
          height: 768,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        materialOptions: MaterialOptions(
          statusBarColor: "#0097e6",
          actionBarColor: "#0097e6",
          actionBarTitle: "เลือกรูปหอพัก",
          allViewTitle: "รูปทั้งหมด",
          useDetailsView: true,
          selectCircleStrokeColor: "#f5f6fa",
        ),
      );
    } catch (e) {}

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildGridView(),
    );
    // new Scaffold(
    //   appBar: new AppBar(
    //     backgroundColor: Colors.red[300],
    //     title: const Text('รูปภาพหอพักเพิ่มเติม'),
    //   ),
    //   body: Column(
    //     children: <Widget>[
    //       // Center(child: Text('Error: $_error')),
    //       new Container(
    //         padding: EdgeInsets.only(left: 15, right: 15, top: 10),
    //         child: new Row(
    //           children: <Widget>[
    //             new Icon(Icons.image),
    //             new Text('รูปหอพักเพิ่มเติม:'),
    //           ],
    //         ),
    //       ),
    //       Divider(
    //         color: Colors.grey,
    //       ),
    //       images == null
    //           ? new Container(
    //               padding: EdgeInsets.only(bottom: 10),
    //               child: FloatingActionButton(
    //                 heroTag: "bt2",
    //                 onPressed: loadAssets,
    //                 child: Icon(Icons.add_a_photo),
    //                 backgroundColor: Colors.brown[400],
    //               ),
    //             )
    //           : new Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 new Container(
    //                   padding: EdgeInsets.only(bottom: 10),
    //                   child: RaisedButton.icon(
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                       Navigator.pushReplacement(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (BuildContext context) =>
    //                                   RegisterDataDorm(_userId, images)));
    //                     },
    //                     label: Text(
    //                       'บันทึก',
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     icon: Icon(Icons.save, color: Colors.white),
    //                     color: Colors.green,
    //                   ),
    //                 ),
    //                 new Container(
    //                   padding: EdgeInsets.only(left: 10, bottom: 10),
    //                   child: RaisedButton.icon(
    //                     onPressed: loadAssets,
    //                     label: Text('เลือกใหม่',
    //                         style: TextStyle(color: Colors.white)),
    //                     icon: Icon(Icons.add_a_photo, color: Colors.white),
    //                     color: Colors.blue,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //       images == null
    //           ? Text('ไม่มีรูปภาพที่เลือก')
    //           : Expanded(
    //               child: buildGridView(),
    //             ),
    //     ],
    //   ),
    // );
  }
}
