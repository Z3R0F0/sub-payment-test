import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/subscription_state_res.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_android_res.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_ios_res.dart';

// Абстрактный класс, представляющий состояние подписки.
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

// Состояние неудачной инициализации подписки.
class InitializeSubscriptionFailure extends SubscriptionState {
  final String errorMessage;
  const InitializeSubscriptionFailure({required this.errorMessage});
  @override
  String toString() => 'InitializeSubscriptionFailure';
}

// Состояние успешной инициализации подписки.
class InitializeSubscriptionSuccess extends SubscriptionState {
  final String response;
  const InitializeSubscriptionSuccess({required this.response});
  @override
  String toString() => 'InitializeSubscriptionSuccess';
}

// Состояние неинициализированных продуктов подписки.
class GetSubscriptionProductsUninitialized extends SubscriptionState {}

// Состояние неудачи при получении продуктов подписки.
class GetSubscriptionProductsFailure extends SubscriptionState {
  final String errorMessage;
  const GetSubscriptionProductsFailure({required this.errorMessage});
  @override
  String toString() => 'GetSubscriptionProductsFailure';
}

// Состояние успешного получения продуктов подписки.
class GetSubscriptionProductsSuccess extends SubscriptionState {
  final List<IAPItem> iapItems;
  const GetSubscriptionProductsSuccess({required this.iapItems});
  @override
  String toString() => 'GetSubscriptionProductsSuccess';
}

// Состояние неинициализированных предыдущих покупок.
class GetPastPurchasesUninitialized extends SubscriptionState {}

// Состояние неудачи при получении предыдущих покупок.
class GetPastPurchasesFailure extends SubscriptionState {
  final String errorMessage;
  const GetPastPurchasesFailure({required this.errorMessage});
  @override
  String toString() => 'GetPastPurchasesFailure';
}

// Состояние успешного получения предыдущих покупок.
class GetPastPurchasesSuccess extends SubscriptionState {
  final List<PurchasedItem> purchasedItems;
  const GetPastPurchasesSuccess({required this.purchasedItems});
  @override
  String toString() => 'GetPastPurchasesSuccess';
}

// Состояние загрузки при покупке продукта подписки.
class PurchaseSubscriptionProductLoading extends SubscriptionState {}

// Состояние завершения загрузки при покупке продукта подписки.
class PurchaseSubscriptionProductStopLoading extends SubscriptionState {}

// Состояние неудачи при покупке продукта подписки.
class PurchaseSubscriptionProductFailure extends SubscriptionState {
  final String errorMessage;
  const PurchaseSubscriptionProductFailure({required this.errorMessage});
  @override
  String toString() => 'PurchaseSubscriptionProductFailure';
}

// Состояние успешной покупки продукта подписки.
class PurchaseSubscriptionProductSuccess extends SubscriptionState {
  final Map<String, String> response;
  const PurchaseSubscriptionProductSuccess({required this.response});
  @override
  String toString() => 'PurchaseSubscriptionProductSuccess';
}

// Состояние загрузки при верификации покупки на Android.
class VerifyPurchaseAndroidLoading extends SubscriptionState {}

// Состояние неудачи при верификации покупки на Android.
class VerifyPurchaseAndroidFailure extends SubscriptionState {
  final String errorMessage;
  const VerifyPurchaseAndroidFailure({required this.errorMessage});
  @override
  String toString() => 'VerifyPurchaseAndroidFailure';
}

// Состояние успешной верификации покупки на Android.
class VerifyPurchaseAndroidSuccess extends SubscriptionState {
  final VerifyReceiptAndroidRes verifyReceiptAndroidRes;
  const VerifyPurchaseAndroidSuccess({required this.verifyReceiptAndroidRes});
  @override
  String toString() => 'VerifyPurchaseAndroidSuccess';
}

// Состояние загрузки при верификации покупки на iOS.
class VerifyPurchaseIOSLoading extends SubscriptionState {}

// Состояние неудачи при верификации покупки на iOS.
class VerifyPurchaseIOSFailure extends SubscriptionState {
  final String errorMessage;
  const VerifyPurchaseIOSFailure({required this.errorMessage});
  @override
  String toString() => 'VerifyPurchaseIOSFailure';
}

// Состояние успешной верификации покупки на iOS.
class VerifyPurchaseIOSSuccess extends SubscriptionState {
  final VerifyReceiptIOSRes verifyReceiptIOSRes;
  const VerifyPurchaseIOSSuccess({required this.verifyReceiptIOSRes});
  @override
  String toString() => 'VerifyPurchaseIOSSuccess';
}

// Состояние загрузки при завершении транзакции.
class CompleteTransactionLoading extends SubscriptionState {}

// Состояние неудачи при завершении транзакции.
class CompleteTransactionFailure extends SubscriptionState {
  final String errorMessage;
  const CompleteTransactionFailure({required this.errorMessage});
  @override
  String toString() => 'CompleteTransactionFailure';
}

// Состояние успешного завершения транзакции.
class CompleteTransactionSuccess extends SubscriptionState {
  final String finishMessage;
  const CompleteTransactionSuccess({required this.finishMessage});
  @override
  String toString() => 'CompleteTransactionSuccess';
}

// Состояние неудачи при завершении подписки.
class FinalizeSubscriptionFailure extends SubscriptionState {
  final String errorMessage;
  const FinalizeSubscriptionFailure({required this.errorMessage});
  @override
  String toString() => 'FinalizeSubscriptionFailure';
}

// Состояние успешного завершения подписки.
class FinalizeSubscriptionSuccess extends SubscriptionState {
  final String response;
  const FinalizeSubscriptionSuccess({required this.response});
  @override
  String toString() => 'FinalizeSubscriptionSuccess';
}

// Состояние неудачи при получении статуса подписки.
class GetSubscriptionStatusFailure extends SubscriptionState {
  final String errorMessage;
  const GetSubscriptionStatusFailure({required this.errorMessage});
  @override
  String toString() => 'GetSubscriptionStatusFailure';
}

// Состояние успешного получения статуса ежемесячной подписки.
class GetMonthlySubscriptionStatusSuccess extends SubscriptionState {
  final SubscriptionStateResponse subscriptionStateResponse;
  const GetMonthlySubscriptionStatusSuccess(
      {required this.subscriptionStateResponse});
  @override
  String toString() => 'GetMonthlySubscriptionStatusSuccess';
}


class GetYearlySubscriptionStatusSuccess extends SubscriptionState {
  final SubscriptionStateResponse subscriptionStateResponse;
  const GetYearlySubscriptionStatusSuccess(
      {required this.subscriptionStateResponse});
  @override
  String toString() => 'GetYearlySubscriptionStatusSuccess';
}

class CheckSubscriptionReadyStatusFailure extends SubscriptionState {
  final String errorMessage;
  const CheckSubscriptionReadyStatusFailure({required this.errorMessage});
  @override
  String toString() => 'CheckSubscriptionReadyStatusFailure';
}

class CheckSubscriptionReadyStatusSuccess extends SubscriptionState {
  @override
  String toString() => 'CheckSubscriptionReadyStatusSuccess';
}
