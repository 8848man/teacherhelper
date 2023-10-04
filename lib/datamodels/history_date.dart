class HistoryDate {
  DateTime checkDate;

  HistoryDate({required this.checkDate}) {
    // 시/분/초 정보를 무시하고 년/월/일 정보만으로 초기화
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
  }

  @override
  bool operator ==(other) {
    // 년/월/일 정보만으로 비교
    return other is HistoryDate &&
        other.checkDate.year == checkDate.year &&
        other.checkDate.month == checkDate.month &&
        other.checkDate.day == checkDate.day;
  }

  @override
  int get hashCode => checkDate.hashCode;
}
