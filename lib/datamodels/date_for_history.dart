class DateForHistory {
  late int startYear;
  late int startMonth;
  late int? startDate;
  late int endYear;
  late int endMonth;
  late int? endDate;

  late DateTime? startDateTime;
  late DateTime? endDateTime;

  DateForHistory({
    required this.startYear,
    required this.startMonth,
    this.startDate,
    required this.endYear,
    required this.endMonth,
    this.endDate,
  }) {
    startDateTime = DateTime(startYear, startMonth, startDate ?? 1);
    endDateTime = DateTime(endYear, endMonth, endDate ?? 30);
  }
}
