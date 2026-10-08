import '../../domain/entities/analytics_entity.dart';
import '../../domain/entities/filter_entity.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsEntity data;
  final FilterEntity currentFilter;

  AnalyticsLoaded({required this.data, required this.currentFilter});
}

class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError(this.message);
}
