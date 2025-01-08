import 'package:testtwo/cubit/product_state.dart';

class ErrorState extends ProductState{
  final String error;
  const ErrorState(this.error);
}