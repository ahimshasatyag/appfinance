import 'package:flutter_bloc/flutter_bloc.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';
import '../../domain/usecases/get_analytics_data_usecase.dart';

export 'analytics_event.dart';
export 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsDataUseCase getAnalyticsDataUseCase;

  AnalyticsBloc({required this.getAnalyticsDataUseCase}) : super(AnalyticsInitial()) {
    on<LoadAnalyticsData>((event, emit) async {
      emit(AnalyticsLoading());
      try {
        final data = await getAnalyticsDataUseCase.execute(event.filter);
        emit(AnalyticsLoaded(data: data, currentFilter: event.filter));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    });
  }
}
