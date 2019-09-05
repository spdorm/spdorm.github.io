import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDormpage.dart';
import 'VendingHome.dart';
import 'Add_AccountIncome.dart';
import 'Datadorm_fragment.dart';
import 'InfromAlert.dart';
import 'firstPage.dart';
import 'home_fragment.dart';
import 'NewsDorm.dart';
import 'StaticVendingMachine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class MainHomeFragment extends StatefulWidget {
  int _dormId, _userId;
  MainHomeFragment(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _MainHomeFragment(_dormId, _userId);
  }
}

class _MainHomeFragment extends State<MainHomeFragment> {
  int _dormId, _userId;
  _MainHomeFragment(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  String _dormName, _name_image = "", _userName = "";

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/findImageDorm',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData['status'] == 0) {
        setState(() {
          _name_image = jsonData['data'];
        });
      } else {
        setState(() {
          _name_image = "";
        });
      }
    });

    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];

      if (jsonData['status'] == 0) {
        http.post('${config.API_url}/user/list',
            body: {"userId": _userId.toString()}).then((response) {
          Map jsonData = jsonDecode(response.body) as Map;
          Map<String, dynamic> dataUsername = jsonData['data'];

          if (jsonData['status'] == 0) {
            setState(() {
              _dormName = data['dormName'];
              _userName = dataUsername['userFirstname'] +
                  ' ' +
                  dataUsername['userLastname'];
            });
          }
        });
      }
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', null);
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

  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    switch (selectedDrawerIndex) {
      case 1:
        return Navigator.pop(context);
      case 2:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => InformAlertPage(_dormId, _userId)));
      case 3:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => NewsDorm(_dormId, _userId)));
      case 4:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => DataDormFragment(_dormId, _userId)));
      case 5:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) =>
                    AccountIncomeFragment(_dormId, _userId)));
      case 6:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => VendingHomePage(_dormId, _userId)));
      case 7:
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) =>
                    StaticVendingPage(_dormId, _userId)));
      default:
        return new Text('ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    int bIndex = 0;

    Future<void> _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('login', false);
    }

    Future<bool> onLogOut() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('คุณต้องการออกจากระบบ ?'),
                actions: <Widget>[
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
                  FlatButton(
                    child: Text('ไม่ใช่'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ));
    }

    void _onTab(int index) {
      setState(() {
        bIndex = index;
      });
      if (bIndex == 0) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext) => AddDormPage(_userId)));
      } else if (bIndex == 1) {
        onLogOut();
      }
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('หน้าหลัก'),
        ),
        body: new HomeFragment(_dormId),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                currentAccountPicture: _name_image != ""
                    ? new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            "${config.API_url}/dorm/image/?nameImage=${_name_image}"))
                    : new CircleAvatar(
                        backgroundImage:
                            new NetworkImage("images/no_image.png")),
                accountName: new Text('${_dormName}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text('${_userName}'),
              ),
              new ListTile(
                title: new Text('หน้าหลัก'),
                leading: new Icon(Icons.home),
                selected: 1 == selectedDrawerIndex,
                onTap: () => onSelectItem(1),
              ),
              new ListTile(
                title: new Text('แจ้งซ่อม'),
                leading: new Icon(Icons.settings),
                selected: 2 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(2);
                },
              ),
              new ListTile(
                title: new Text('เพิ่มข้อมูลข่าวสาร'),
                leading: new Icon(Icons.public),
                selected: 3 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(3);
                },
              ),
              new ListTile(
                title: new Text('ข้อมูลหอพัก'),
                leading: new Icon(Icons.perm_device_information),
                selected: 4 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(4);
                },
              ),
              new ListTile(
                title: new Text('บัญชีรายรับรายจ่าย'),
                leading: new Icon(Icons.note),
                selected: 5 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(5);
                },
              ),
              new ListTile(
                title: new Text('เครื่องหยอดเหรียญ'),
                leading: new Icon(Icons.note_add),
                selected: 6 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(6);
                },
              ),
              new ListTile(
                title: new Text('สถิตเครื่องหยอดเหรียญ'),
                leading: new Icon(Icons.insert_chart),
                selected: 7 == selectedDrawerIndex,
                onTap: () {
                  Navigator.pop(context);
                  onSelectItem(7);
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('หอพักทั้งหมด'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.exit_to_app),
              title: new Text('ออกจากระบบ'),
            ),
          ],
          onTap: (index) {
            _onTab(index);
          },
        ),
      ),
    );
  }
}
