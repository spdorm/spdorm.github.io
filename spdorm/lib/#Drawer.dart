import 'package:flutter/material.dart';
import 'mainNews.dart';

class HomeDorm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeDorm1State();
  }
}

class HomeDorm1State extends State<HomeDorm> {
  int selectedDrawerIndex = 0;

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
       return Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>NewsDorm(1, 1)));
      case 1:
       // return new DataFragmentState();
      case 2:
       // return new CharFragment();
      default:
        return new Text('ERROR');
    }
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ห้องพักทั้งหมด',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('ห้องพักทั้งหมด'),
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
                    title: new Text('ข้อมูลการเช่า'),
                    leading: new Icon(Icons.perm_device_information),
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
                    title: new Text('เพิ่มใบแจ้งชำระ'),
                    leading: new Icon(Icons.note_add),
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
        body: getDrawerItemWidget(selectedDrawerIndex),
      ),
    );
  }
}
