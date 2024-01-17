import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/subscription_state_res.dart';

class GetSubscriptionStatus
    extends CustomUseCase<SubscriptionStateResponse, GetSubscriptionStatusParam> {
  SubscriptionRepository repository;
  GetSubscriptionStatus(this.repository);
  @override
  Future<Either<CustomFailure, SubscriptionStateResponse>> execute(
      GetSubscriptionStatusParam params) {
    return repository.getSubscriptionStatus(params.productId);
  }
}

class GetSubscriptionStatusParam extends NoParams {
  final String productId;
  GetSubscriptionStatusParam(this.productId);

  @override
  List<Object?> get props => [productId];

  @override
  bool? get stringify => true;
}
