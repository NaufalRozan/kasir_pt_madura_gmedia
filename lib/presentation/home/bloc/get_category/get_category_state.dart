part of 'get_category_bloc.dart';

@freezed
class GetCategoryState with _$GetCategoryState {
  const factory GetCategoryState.initial() = _Initial;
  const factory GetCategoryState.loading() = _Loading;
  const factory GetCategoryState.success(CategoryResponseModel data) = _Success;
  const factory GetCategoryState.error(String message) = _Error;
}
