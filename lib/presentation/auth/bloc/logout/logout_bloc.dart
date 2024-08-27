import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/auth_remote_datasource.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  LogoutBloc(this._authRemoteDatasource) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const _Loading());
      print('Logout initiated');
      final result = await _authRemoteDatasource.logout();
      result.fold(
        (l) {
          print('Logout failed: $l');
          emit(_Error(l));
        },
        (r) {
          print('Logout succeeded: $r');
          emit(const _Success());
        },
      );
    });
  }
}
