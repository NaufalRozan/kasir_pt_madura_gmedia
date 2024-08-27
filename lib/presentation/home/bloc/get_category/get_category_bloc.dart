import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_gmedia_test/data/datasources/category_remote_datasource.dart';

import '../../../../data/models/category_response_model.dart';

part 'get_category_event.dart';
part 'get_category_state.dart';
part 'get_category_bloc.freezed.dart';

class GetCategoryBloc extends Bloc<GetCategoryEvent, GetCategoryState> {
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  GetCategoryBloc(this._categoryRemoteDataSource) : super(const _Initial()) {
    on<_GetCategory>((event, emit) async {
      emit(const _Loading());
      final result = await _categoryRemoteDataSource.getCategory();
      result.fold(
        (failure) => emit(GetCategoryState.error(failure)),
        (categoryData) => emit(GetCategoryState.success(categoryData)),
      );
    });
  }
}
