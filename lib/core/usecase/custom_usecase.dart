import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';

abstract class CustomUseCase<Type, Params> {
  Future<Either<CustomFailure, Type>> execute(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
