import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';

class CheckSubscriptionReadyStatus extends CustomUseCase<int, NoParams> {
  SubscriptionRepository repository;
  CheckSubscriptionReadyStatus(this.repository);
  @override
  Future<Either<CustomFailure, int>> execute(NoParams params) {
    return repository.checkSubscriptionReadyStatus();
  }
}
