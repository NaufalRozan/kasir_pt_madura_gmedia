import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/product_remote_datasource.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';
part 'delete_product_bloc.freezed.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final ProductRemoteDataSource _productRemoteDataSource;

  DeleteProductBloc(this._productRemoteDataSource) : super(const _Initial()) {
    on<_DeleteProduct>((event, emit) async {
      emit(const _Loading());
      final result = await _productRemoteDataSource.deleteProduct(event.productId);
      result.fold(
        (failure) => emit(DeleteProductState.error(failure)),
        (successMessage) => emit(DeleteProductState.success(successMessage)),
      );
    });
  }
}
