import '../../domain/entities/dashboard_data_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardDataEntity> getDashboardData() async {
    try {
      final data = await remoteDataSource.getDashboardData();
      return data;
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }
}
