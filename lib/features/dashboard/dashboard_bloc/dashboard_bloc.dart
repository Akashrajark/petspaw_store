import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitialState()) {
    on<DashboardEvent>((event, emit) async {
      try {
        emit(DashboardLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        final response = await supabaseClient.rpc('get_count');

        emit(DashboardSuccessState(data: response));
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(DashboardFailureState());
      }
    });
  }
}
