import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class GetSubscriptionProducts
    extends CustomUseCase<List<IAPItem>, GetSubscriptionProductsParam> {
  final SubscriptionRepository repository;
  GetSubscriptionProducts(this.repository);
  @override
  Future<Either<CustomFailure, List<IAPItem>>> execute(
      GetSubscriptionProductsParam params) async {
    return await repository.getSubscriptionProducts(params.productsIds);
  }
}

class GetSubscriptionProductsParam extends NoParams {
  final List<String> productsIds;
  GetSubscriptionProductsParam(this.productsIds);

  @override
  List<Object?> get props => [productsIds];

  @override
  bool? get stringify => true;
}
