class convertDateTime {
  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ].toList();

  String convertToThai(String _dateTime) {
    print(_dateTime);
    String _month = "";
    if (_dateTime.substring(5, 6) == "0") {
      for (int j = 0; j < _Month.length; j++) {
        if (_dateTime.substring(6, 7) == '${j}') {
          _month = _Month[j - 1];
        }
      }
    } else if (_dateTime.substring(5, 6) == "1") {
      for (int i = 0; i < _Month.length; i++) {
        if ('${int.parse(_dateTime.substring(5, 7)) - 1}' == '${i}') {
          _month = _Month[i];
        }
      }
    }
    return '${_dateTime.substring(8, 10)} ${_month} ${int.parse(_dateTime.substring(0, 4)) + 543}';
  }

  String convertMonthToThai(String _month) {
    for (int i = 0; i < _Month.length - 1; i++) {
      if (_month == "01") {
        return _Month[0];
      } else if (_month == "02") {
        return _Month[1];
      } else if (_month == "03") {
        return _Month[2];
      } else if (_month == "04") {
        return _Month[3];
      } else if (_month == "05") {
        return _Month[4];
      } else if (_month == "06") {
        return _Month[5];
      } else if (_month == "07") {
        return _Month[6];
      } else if (_month == "08") {
        return _Month[7];
      } else if (_month == "09") {
        return _Month[8];
      } else if (_month == "10") {
        return _Month[9];
      } else if (_month == "11") {
        return _Month[10];
      } else if (_month == "12") {
        return _Month[11];
      }
    }
  }
}
