import '../../domain/entities/filter_entity.dart';

abstract class AnalyticsEvent {}

class LoadAnalyticsData extends AnalyticsEvent {
  final FilterEntity filter;

  LoadAnalyticsData(this.filter);
}
