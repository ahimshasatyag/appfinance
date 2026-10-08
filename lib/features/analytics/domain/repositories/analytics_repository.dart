import '../entities/analytics_entity.dart';
import '../entities/filter_entity.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsEntity> getAnalytics(FilterEntity filter);
}
