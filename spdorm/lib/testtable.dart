import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AccountIncome(),
  ));
}

class AccountIncome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AccountIncomeState();
  }
}

class _AccountIncomeState extends State<AccountIncome> {
  int selectedDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('DataTable Sample')),
        body: Container(
          child: Table(
            border: TableBorder.all(),
            columnWidths: {
            0: FractionColumnWidth(.3)
          }, 
          children: [
            TableRow(children: [
              Text(
                "เดือน",
                textAlign: TextAlign.center,
              ),
              Text(
                "รายรับ",
                textAlign: TextAlign.center,
              ),
              Text(
                "รายจ่าย",
                textAlign: TextAlign.center,
              ),
              Text(
                "กำไร",
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                "มกราคม",
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'กุมภาพันธ์',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'มีนาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'เมษายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'พฤษภาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'มิถุนายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'กรกฎาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'สิงหาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'กันยายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'ตุลาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'พฤษจิกายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'ธันวาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              Text(
                '12',
                textAlign: TextAlign.center,
              ),
            ]),
          ]),
        ));
  }
}
