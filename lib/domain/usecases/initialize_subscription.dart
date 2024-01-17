import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';

class InitializeSubscription extends CustomUseCase<dynamic, NoParams> {
  final SubscriptionRepository repository;
  InitializeSubscription(this.repository);
  @override
  Future<Either<CustomFailure, dynamic>> execute(NoParams params) {
    return repository.initializeSubscription();
  }
}
