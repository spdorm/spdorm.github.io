import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomDormPage.dart';
import 'InformPage.dart';
import 'firstPage.dart';
import 'listPayment.dart';
import 'PersonalInformationPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class mainHomDorm extends StatefulWidget {
  int _dormId, _userId, _roomId;
  mainHomDorm(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new mainHomDormState(_dormId, _userId, _roomId);
  }
}

class mainHomDormState extends State<mainHomDorm> {
  int selectedDrawerIndex = 0;
  int _dormId, _userId, _roomId;
  mainHomDormState(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  String _Username, _Firstname, _userLastname, _Address, _Email, _Telephone,_dormName;

  TextEditingController userFirstname = TextEditingController();
  TextEditingController userLastname = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userTelephone = TextEditingController();

  void initState() {
    super.initState();
    http.post('${config.API_url}/user/list',
        body: {"userId": _userId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];
      setState(() {
        _Username = data['userUsername'];
        _Email = data['userEmail'];
        userFirstname.text = data['userFirstname'];
        userLastname.text = data['userLastname'];
        userAddress.text = data['userAddress'];
        userTelephone.text = data['userTelephone'];
      });
    });

    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];
      setState(() {
        _dormName = data['dormName'];
      });
    });
  }

  

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', null);
    print(prefs.getInt('id'));
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    switch (selectedDrawerIndex) {
      case 1:
        return Navigator.pop(context);
      case 2:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => PersonalFragment(_dormId, _userId, _roomId)));
      case 3:
        return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) =>
                      InformMultiLine(_dormId,_userId,_roomId, _Username)));
      case 4:
        return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) =>
                      ListPaymentPage(_dormId, _userId, _roomId)));
      case 5:
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('คุณต้องการออกจากระบบ ?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _logout().then((_) {
                          prefix0.Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => Login()));
                        });
                      },
                      child: Text('ตกลง'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('ยกเลิก'),
                    ),
                  ],
                ));
      default:
        return new Text('ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${_dormName}'),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${_Username}"),
              accountEmail: Text("${_Email}"),
              currentAccountPicture: CircleAvatar(
                // backgroundColor:
                //     Theme.of(context).platform == TargetPlatform.iOS
                //         ? Colors.blue
                //         : Colors.white,
                child: Image.asset("images/2.png"),
              ),
            ),
            new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text('หน้าหลัก'),
                  leading: new Icon(Icons.home,color: Colors.indigo),
                  selected: 1 == selectedDrawerIndex,
                  onTap: () => onSelectItem(1),
                ),
                new ListTile(
                  title: new Text('ข้อมูลส่วนตัว'),
                  leading: new Icon(Icons.person,color: Colors.green),
                  selected: 2 == selectedDrawerIndex,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectItem(2);
                  },
                ),
                new ListTile(
                  title: new Text('การแจ้งซ่อม'),
                  leading: new Icon(Icons.settings,color: Colors.brown[600]),
                  selected: 3 == selectedDrawerIndex,
                onTap: () {
                    Navigator.pop(context);
                    onSelectItem(3);
                  },
                ),
                new ListTile(
                  title: new Text('ใบเสร็จชำระเงิน'),
                  leading: new Icon(Icons.monetization_on,color: Colors.yellow[700]),
                  selected: 4 == selectedDrawerIndex,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectItem(4);
                  },
                ),
                new ListTile(
                  title: new Text('ออกจากระบบ'),
                  leading: new Icon(Icons.exit_to_app,color: Colors.red[200],),
                  selected: 5 == selectedDrawerIndex,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectItem(5);
                  },
                )
              ],
            ),
          ],
        ),
      ),
      body: new HomDormPage(_dormId, _userId),
    );
  }
}
