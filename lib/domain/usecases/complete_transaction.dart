import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/core/usecase/custom_usecase.dart';
import 'package:cloudipsp_mobile_example/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class CompleteTransaction extends CustomUseCase<dynamic, CompleteTransactionParam> {
  SubscriptionRepository repository;
  CompleteTransaction(this.repository);
  @override
  Future<Either<CustomFailure, dynamic>> execute(CompleteTransactionParam params) {
    if (Platform.isIOS) {
      return repository.completeTransaction(
          transactionId: params.transactionId ?? "");
    } else {
      return repository.completeTransaction(
          item: params.purchasedItem!,
          transactionId: params.transactionId ?? "",
          isConsumable: params.isConsumable ?? false);
    }
  }
}

class CompleteTransactionParam extends NoParams {
  final PurchasedItem? purchasedItem;
  final String? transactionId;
  final bool? isConsumable;
  CompleteTransactionParam(
      {this.purchasedItem, this.transactionId, this.isConsumable});

  @override
  List<Object?> get props => [purchasedItem, transactionId, isConsumable];

  @override
  bool? get stringify => true;
}
