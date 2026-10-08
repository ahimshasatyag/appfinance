import '../../domain/entities/analytics_entity.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl(this.remoteDataSource);

  @override
  Future<AnalyticsEntity> getAnalytics(FilterEntity filter) async {
    try {
      return await remoteDataSource.getAnalytics(filter);
    } catch (e) {
      throw Exception('Failed to load analytics data: $e');
    }
  }
}
