import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDataDormpage.dart';
import 'dart:convert';
import 'config.dart';
import 'main.dart';
import 'mainHomeFragment.dart';

class AddDormPage extends StatefulWidget {
  int _userId;

  AddDormPage(int userId) {
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddDormPage(_userId);
  }
}

class _AddDormPage extends State {
  int _userId;

  _AddDormPage(int userId) {
    this._userId = userId;
    print(this._userId);
  }

  List lst = new List();
  var img;

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', false);
    print(prefs.getBool('login'));
  }

  Future<bool> onLogOut() {
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
                        _logout().then((res) => {
                              Navigator.pop(context),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext) => Login()))
                            }),
                      },
                ),
              ],
            ));
  }

  void initState() {
    super.initState();

    http.post('${config.API_url}/dorm/findInfo',
        body: {"userId": _userId.toString()}).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body);
      List temp = jsonData["data"];

      for (int i = 0; i < temp.length; i++) {
        List data = temp[i];
        http.post('${config.API_url}/dorm/findImageDorm',
            body: {"dormId": data[0].toString()}).then((response) {
          print(response.body);
          Map jsonData = jsonDecode(response.body) as Map;
          String _name_image = jsonData['data'];
          setState(() {});

          Container test = Container(
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.all(5.0),
            padding: new EdgeInsets.all(5.0),
            height: 150.0,
            decoration: new BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              boxShadow: [
                new BoxShadow(
                    color: Colors.black54,
                    offset: new Offset(2.0, 2.0),
                    blurRadius: 5.0)
              ],
            ),
            child: new Row(
              children: <Widget>[
                _name_image == null
                    ? new CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            '${config.url_upload}/upload/image/no_image.png'),
                      )
                    : new CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            '${config.url_upload}/upload/image/dorm/${_name_image}'),
                      ),
                new Expanded(
                    child: new Padding(
                  padding: new EdgeInsets.only(left: 8.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        '${data[6]}',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      new Wrap(
                        spacing: 2.0,
                        children: <Widget>[
                          new Chip(label: new Text('Hot')),
                          new Chip(label: new Text('Hot')),
                          new Chip(label: new Text('Hot')),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          );

          FlatButton dormInfo = FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext) =>
                          MainHomeFragment(data[0], data[12])));
            },
            child: Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.all(5.0),
              padding: new EdgeInsets.all(5.0),
              height: 150.0,
              decoration: new BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black54,
                      offset: new Offset(2.0, 2.0),
                      blurRadius: 5.0)
                ],
              ),
              child: new Row(
                children: <Widget>[
                  _name_image == null
                      ? new CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              '${config.url_upload}/upload/image/no_image.png'),
                        )
                      : new CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              '${config.url_upload}/upload/image/dorm/${_name_image}'),
                        ),
                  new Expanded(
                      child: new Padding(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          '${data[6]}',
                          style: new TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        new Wrap(
                          spacing: 2.0,
                          children: <Widget>[
                            new Chip(label: new Text('Hot')),
                            new Chip(label: new Text('Hot')),
                            new Chip(label: new Text('Hot')),
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
          lst.add(dormInfo);
          setState(() {});
        });
      }
      FlatButton addButton = FlatButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) => RegisterDataDorm(_userId)));
        },
        child: Container(
          alignment: Alignment.centerLeft,
          margin: new EdgeInsets.all(5.0),
          padding: new EdgeInsets.all(5.0),
          height: 50.0,
          decoration: new BoxDecoration(
            color: Colors.lightBlue[200],
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black54,
                  offset: new Offset(2.0, 2.0),
                  blurRadius: 5.0)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
      lst.add(addButton);
      setState(() {});
    });
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('คุณต้องการออกจากระบบ ?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('ตกลง'),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  FlatButton(
                    child: Text('ยกเลิก'),
                    onPressed: () => Navigator.pop(context, false),
                  )
                ],
              ));
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: Text('หอพักทั้งหมด'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: onLogOut,
                ),
              ],
            ),
            body:
                ListView.builder(itemBuilder: buildBody, itemCount: lst.length),
          ),
        ));
  }
}
