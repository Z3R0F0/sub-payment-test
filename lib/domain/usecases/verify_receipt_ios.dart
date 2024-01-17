import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_ios_res.dart';

class VerifyReceiptIOS
    extends CustomUseCase<VerifyReceiptIOSRes, VerifyReceiptIOSParam> {
  final SubscriptionRepository repository;
  VerifyReceiptIOS(this.repository);
  @override
  Future<Either<CustomFailure, VerifyReceiptIOSRes>> execute(
      VerifyReceiptIOSParam params) {
    return repository.verifyReceiptForIOS(params.purchaseReceiptIOS);
  }
}

class VerifyReceiptIOSParam implements NoParams {
  final PurchaseReceiptIOS purchaseReceiptIOS;

  VerifyReceiptIOSParam(this.purchaseReceiptIOS);

  @override
  List<Object?> get props => [purchaseReceiptIOS];

  @override
  bool? get stringify => true;
}
