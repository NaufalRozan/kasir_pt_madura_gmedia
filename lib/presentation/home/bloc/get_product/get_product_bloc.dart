import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/product_remote_datasource.dart';
import '../../../../data/models/product_response_model.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';
part 'get_product_bloc.freezed.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRemoteDataSource _productRemoteDataSource;

  GetProductBloc(this._productRemoteDataSource) : super(const _Initial()) {
    on<_GetProductsByCategory>((event, emit) async {
      emit(const _Loading());
      final result = await _productRemoteDataSource
          .getProductsByCategory(event.categoryId);
      result.fold(
        (failure) => emit(GetProductState.error(failure)),
        (productData) => emit(GetProductState.success(productData)),
      );
    });
  }
}
