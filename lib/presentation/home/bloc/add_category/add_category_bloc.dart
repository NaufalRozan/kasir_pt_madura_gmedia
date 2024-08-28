import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/category_remote_datasource.dart';
import '../../../../data/models/add_category_response_model.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';
part 'add_category_bloc.freezed.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  AddCategoryBloc(this._categoryRemoteDataSource) : super(const _Initial()) {
    on<_AddCategory>((event, emit) async {
      emit(const _Loading());
      final result = await _categoryRemoteDataSource.addCategory(event.name);
      result.fold(
        (failure) => emit(AddCategoryState.error(failure)),
        (categoryData) => emit(AddCategoryState.success(categoryData)),
      );
    });
  }
}
