import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class GetPastPurchases extends CustomUseCase<List<PurchasedItem>?, NoParams> {
  final SubscriptionRepository repository;
  GetPastPurchases(this.repository);
  @override
  Future<Either<CustomFailure, List<PurchasedItem>?>> execute(NoParams params) async {
    return await repository.getPastPurchases();
  }
}
