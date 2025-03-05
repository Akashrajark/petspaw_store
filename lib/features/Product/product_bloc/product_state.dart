part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductGetSuccessState extends ProductState {
  final List<Map<String, dynamic>> products;

  ProductGetSuccessState({
    required this.products,
  });
}

class ProductSuccessState extends ProductState {}

class ProductFailureState extends ProductState {
  final String message;
  ProductFailureState({this.message = apiErrorMessage});
}
