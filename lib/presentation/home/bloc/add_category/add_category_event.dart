part of 'add_category_bloc.dart';

@freezed
class AddCategoryEvent with _$AddCategoryEvent {
  const factory AddCategoryEvent.addCategory(String name) = _AddCategory;
}
