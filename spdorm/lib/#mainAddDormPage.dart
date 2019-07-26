import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDormpage.dart';
import 'main.dart';
import 'mainNews.dart';

class MainAddDormPage extends StatefulWidget {
  int _userId;
  MainAddDormPage(int userId) {
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _MainAddDormPage(_userId);
  }
}

class _MainAddDormPage extends State<MainAddDormPage> {
  int _userId;
  _MainAddDormPage(int userId) {
    this._userId = userId;
  }

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

  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    switch (selectedDrawerIndex) {
      case 1:
        return Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>NewsDorm(1, 1)));
      case 2:
      // return new DataFragmentState();
      case 3:
      // return new CharFragment();
      default:
        return new Text('ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ดูขรายละเอียด้อมูลห้องพัก',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('หอพัก'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
                print('Search button');
              },
            ),
            FlatButton(
              onPressed: onLogOut,
              child: Text(
                'Logout',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
        body: new AddDormPage(_userId),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.mail),
              title: new Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: new Text('Profile'),
            )
          ],
        ),
      ),
    );
  }
}
