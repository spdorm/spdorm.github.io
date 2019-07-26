import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(new Demo());

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with TickerProviderStateMixin {
  int _currentIndex = 0;
  Map<DateTime, List<RankingBase>> _playerDateRanking;
  TabController controller;
  List<_NavigationIconView> _navigationIconViews;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    _navigationIconViews = <_NavigationIconView>[
      _NavigationIconView(
        icon: Icon(Icons.calendar_view_day),
        title: 'Nav0',
        color: Colors.deepOrange,
        vsync: this,
      ),
      _NavigationIconView(
        icon: Icon(Icons.date_range),
        title: 'Nav1',
        color: Colors.deepOrange,
        vsync: this,
      ),
    ];

    _playerDateRanking = {
      DateTime(2018, 9, 10): [
        PlayerRanking('Tony', 7, 6, 140, 110, 80),
        PlayerRanking('John', 7, 2, 120, 130, 56),
        PlayerRanking('Mike', 8, 5, 120, 130, 70),
        PlayerRanking('Clar', 6, 2, 100, 134, 63)
      ],
      DateTime(2018, 9, 12): [
        PlayerRanking('Tony', 7, 6, 140, 110, 80),
        PlayerRanking('John', 7, 2, 120, 130, 56),
        PlayerRanking('Mike', 8, 5, 120, 130, 70),
        PlayerRanking('Clare', 6, 2, 100, 134, 63),
        PlayerRanking('Jo', 5, 1, 100, 134, 63)
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[Text('Tab1'), Text('Tab2')],
          ),
        ),
        body: TabBarView(
          controller: controller, //TabController(length: 2, vsync: this),
          children: <Widget>[
            buildRankingTable(_currentIndex),
            Text('TEst'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _navigationIconViews.map((x) => x.item).toList(),
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget buildRankingTable(int currentIndex) {
    if (currentIndex == 0) {
      return RankingTable(_playerDateRanking, dateFormatter: 'yMMMEd');
    } else if (currentIndex == 1) {
      return RankingTable(_playerDateRanking,
          dateFormatter: 'MMMM'); // different date formatter here!
    }
    return Text('TODO...');
  }
}

class _NavigationIconView {
  _NavigationIconView({
    Widget icon,
    //Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          //   activeIcon: activeIcon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }
  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;
}

class PlayerRanking extends RankingBase {
  String name;
  PlayerRanking(this.name, played, won, pointsWon, pointsLost, duration)
      : super(played, won, pointsWon, pointsLost, duration);
}

class RankingBase {
  DateTime date;
  int won;
  int played;
  int duration;
  int pointsWon;
  int pointsLost;
  double get winRatio => won / played;
  RankingBase(
      this.played, this.won, this.pointsWon, this.pointsLost, this.duration);

  static int performanceSort(RankingBase rb1, RankingBase rb2) {
    if (rb1.winRatio > rb2.winRatio) return -1;
    if (rb1.winRatio < rb2.winRatio) return 1;
    if (rb1.played > rb2.played) return -1;
    if (rb2.played == rb2.played) return rb1.pointsWon.compareTo(rb2.pointsWon);
    return -1;
  }
}

// this puts a scrollable datatable and optionally a header widget into a ListView
class RankingTable extends StatefulWidget {
  final Map<DateTime, List<RankingBase>> rankingMap;
  final bool hasHeaderWidget;
  final String dateFormatter;
  //final bool isPlayer;
  RankingTable(this.rankingMap,
      {this.dateFormatter, this.hasHeaderWidget = true});

  @override
  _RankingTableState createState() => _RankingTableState(this.rankingMap,
      dateFormatter: this.dateFormatter, hasHeaderWidget: this.hasHeaderWidget);
}

class _RankingTableState extends State<RankingTable> {
  Map<DateTime, List<RankingBase>> rankingMap;
  final bool hasHeaderWidget;
  final String dateFormatter;
  //final bool isPlayer;
  _RankingTableState(this.rankingMap,
      {this.dateFormatter, this.hasHeaderWidget = true});

  DateTime _selectedDate;

  @override
  initState() {
    super.initState();
    _selectedDate = rankingMap.keys.last;
  }

  DataTable buildRankingTable() {
    rankingMap[_selectedDate].sort(RankingBase.performanceSort);
    String nameOrPair =
    rankingMap[_selectedDate].first is PlayerRanking ? 'Name' : 'Pair';
    int rank = 1;

    return DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('Rank')),
        DataColumn(label: Text(nameOrPair)),
        DataColumn(label: Text('Played')),
        DataColumn(label: Text('Win Ratio')),
        DataColumn(label: Text('Points Won-Loss')),
        DataColumn(label: Text('Duration')),
      ],
      rows: rankingMap[_selectedDate].map((RankingBase pr) {
        DataCell titleCell;
        if (pr is PlayerRanking)
          titleCell = DataCell(Text('${pr.name}'));
        else {
          // var pair = pr as PairRanking;
          // titleCell = DataCell(Text('${pair.player1Name}\n${pair.player2Name}'));
        }
        return DataRow(cells: [
          DataCell(Text('${rank++}')),
          titleCell,
          DataCell(Text('${pr.played}')),
          DataCell(Text('${NumberFormat("0.##%").format(pr.won / pr.played)}')),
          DataCell(Text('${pr.pointsWon} - ${pr.pointsLost}')),
          DataCell(Text('${pr.duration}')),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenWidgets = [];
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: childrenWidgets,
    );
  }
}