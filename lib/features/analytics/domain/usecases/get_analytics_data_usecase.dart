import '../entities/analytics_entity.dart';
import '../entities/filter_entity.dart';
import '../repositories/analytics_repository.dart';

class GetAnalyticsDataUseCase {
  final AnalyticsRepository repository;

  GetAnalyticsDataUseCase(this.repository);

  Future<AnalyticsEntity> execute(FilterEntity filter) {
    return repository.getAnalytics(filter);
  }
}
