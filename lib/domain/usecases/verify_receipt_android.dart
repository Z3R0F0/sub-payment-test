import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_android_res.dart';

class VerifyReceiptAndroid
    extends CustomUseCase<VerifyReceiptAndroidRes, VerifyReceiptAndroidParam> {
  final SubscriptionRepository repository;
  VerifyReceiptAndroid(this.repository);
  @override
  Future<Either<CustomFailure, VerifyReceiptAndroidRes>> execute(
      VerifyReceiptAndroidParam params) {
    return repository.verifyReceiptForAndroid(
        params.purchaseReceiptAndroid, params.purchasedItem);
  }
}

class VerifyReceiptAndroidParam implements NoParams {
  final PurchaseReceiptAndroid purchaseReceiptAndroid;
  final PurchasedItem purchasedItem;

  VerifyReceiptAndroidParam(this.purchaseReceiptAndroid, this.purchasedItem);

  @override
  List<Object?> get props => [purchaseReceiptAndroid, purchasedItem];

  @override
  bool? get stringify => true;
}
