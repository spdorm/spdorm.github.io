import 'package:flutter/material.dart';
import 'ViewRoomPage.dart';

class mainViewRoom extends StatefulWidget {
  int _dormId,_userId,_roomId;
  mainViewRoom(int dormId,int userId, int roomId){
    this._dormId = dormId;
    this._userId=userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _mainViewRoomState(_dormId,_userId,_roomId);
  }
}

class _mainViewRoomState extends State<mainViewRoom> {
  int _dormId,_userId,_roomId;
  _mainViewRoomState(int dormId,int userId, int roomId){
    this._dormId = dormId;
    this._userId=userId;
    this._roomId = roomId;
    print(_roomId);
  }

  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ดูขรายละเอียด้อมูลห้องพัก',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('รายละเอียดห้องพัก'),
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
            IconButton(
              icon: Icon(
                Icons.tune,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                print('Filter button');
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  'SPDorm',
                ),
                accountEmail: null,
              ),
              new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text('เพิ่มข้อมูลข่าวสาร'),
                    leading: new Icon(Icons.view_compact),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  ),
                  new ListTile(
                    title: new Text('ข้อมูลหอพัก'),
                    leading: new Icon(Icons.note),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  ),
                  new ListTile(
                    title: new Text('บัญชีรายรับรายจ่าย'),
                    leading: new Icon(Icons.note),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  ),
                  new ListTile(
                    title: new Text('สถิติเครื่องซักผ้าหยอดเหรียญ'),
                    leading: new Icon(Icons.insert_chart),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  ),
                  new ListTile(
                    title: new Text('ออกจากระบบ'),
                    leading: new Icon(Icons.exit_to_app),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  )
                ],
              ),
            ],
          ),
        ),
        body: new ViewRoomPage(_dormId,_userId,_roomId),
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
