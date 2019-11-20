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
}
