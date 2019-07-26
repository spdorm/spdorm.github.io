import 'package:flutter/material.dart';
import 'DataRoom.dart';

void main(){
  runApp(MaterialApp(
    home: Data_Room(),
  ));
}

class Data_Room extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Data_Room();
  }
}

class _Data_Room extends State<Data_Room> {
  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'แสดงข้อมูลลูกค้า',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('ห้อง 101'),
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
        body: new DataRoom(),
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
