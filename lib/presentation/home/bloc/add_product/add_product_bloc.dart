import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/product_remote_datasource.dart';
import '../../../../data/models/add_product_response_model.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';
part 'add_product_bloc.freezed.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRemoteDataSource _productRemoteDataSource;

  AddProductBloc(this._productRemoteDataSource) : super(const _Initial()) {
    on<_AddProduct>((event, emit) async {
      emit(const _Loading());

      final result = await _productRemoteDataSource.addProduct(
        categoryId: event.categoryId,
        name: event.name,
        price: event.price,
        picturePath: event.picturePath,
      );

      result.fold(
        (failure) => emit(AddProductState.error(failure)),
        (productData) => emit(AddProductState.success(productData)),
      );
    });
  }
}

