import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';

class PurchaseSubscriptionProduct
    extends CustomUseCase<Map<String, String>, PurchaseSubscriptionProductParam> {
  SubscriptionRepository repository;
  PurchaseSubscriptionProduct(this.repository);
  @override
  Future<Either<CustomFailure, Map<String, String>>> execute(
      PurchaseSubscriptionProductParam params) {
    return repository.purchaseSubscriptionProduct(params.productId,
        isUpgrade: params.isUpgrade);
  }
}

class PurchaseSubscriptionProductParam extends NoParams {
  final String productId;
  final bool isUpgrade;
  PurchaseSubscriptionProductParam(this.productId, this.isUpgrade);

  @override
  List<Object?> get props => [productId, isUpgrade];

  @override
  bool? get stringify => true;
}
