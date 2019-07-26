import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomDormPage.dart';
import 'InformPage.dart';
import 'PaymentNotificationPage.dart';
import 'PersonalInformationPage.dart';
import 'main.dart';

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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', false);
    print(prefs.getBool('login'));
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    switch (selectedDrawerIndex) {
      case 1:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => PersonalFragment(_userId)));
      case 2:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) =>
                    InformMultiLine(_dormId, _userId, _roomId)));
      case 3:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => PaymentmultiLine(_dormId,_roomId)));
      case 4:
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
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'แสดงข้อมูลข่าวสาร',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('หน้าหลัก'),
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  'หน้าหลัก',
                ),
                accountEmail: null,
              ),
              new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text('ข้อมูลส่วนตัว'),
                    leading: new Icon(Icons.person),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  ),
                  new ListTile(
                    title: new Text('การแจ้งซ่อม'),
                    leading: new Icon(Icons.settings),
                    selected: 2 == selectedDrawerIndex,
                    onTap: () => onSelectItem(2),
                  ),
                  new ListTile(
                    title: new Text('ใบเสร็จชำระเงิน'),
                    leading: new Icon(Icons.monetization_on),
                    selected: 3 == selectedDrawerIndex,
                    onTap: () => onSelectItem(3),
                  ),
                  new ListTile(
                    title: new Text('ออกจากระบบ'),
                    leading: new Icon(Icons.exit_to_app),
                    selected: 4 == selectedDrawerIndex,
                    onTap: () => onSelectItem(4),
                  )
                ],
              ),
            ],
          ),
        ),
        body: new HomDormPage(_dormId, _userId),
      ),
    );
  }
}
