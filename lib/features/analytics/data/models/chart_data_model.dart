class ChartDataModel {
  final String label;
  final double value1;
  final double value2;

  ChartDataModel({
    required this.label,
    required this.value1,
    this.value2 = 0,
  });
}
