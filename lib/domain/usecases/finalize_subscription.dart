import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';

class FinalizeSubscription extends CustomUseCase<dynamic, NoParams> {
  final SubscriptionRepository repository;
  FinalizeSubscription(this.repository);
  @override
  Future<Either<CustomFailure, dynamic>> execute(NoParams params) {
    return repository.finalizeSubscription();
  }
}
