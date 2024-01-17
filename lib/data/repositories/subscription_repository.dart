import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:cloudipsp_mobile_example/core/error/exception.dart';
import 'package:cloudipsp_mobile_example/data/datasources/subscription_datasource.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/subscription_state_res.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_android_res.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/verify_receipt_ios_res.dart';

abstract class SubscriptionRepository {
  Future<Either<CustomFailure, String?>> initializeSubscription();

  Future<Either<CustomFailure, int>> checkSubscriptionReadyStatus();

  Future<Either<CustomFailure, List<IAPItem>>> getSubscriptionProducts(
      List<String> products);

  Future<Either<CustomFailure, List<PurchasedItem>?>> getPastPurchases();

  Future<Either<CustomFailure, Map<String, String>>>
      purchaseSubscriptionProduct(String productId, {bool isUpgrade = false});

  Future<Either<CustomFailure, VerifyReceiptAndroidRes>>
      verifyReceiptForAndroid(PurchaseReceiptAndroid purchaseReceiptAndroid,
          PurchasedItem purchasedItem);

  Future<Either<CustomFailure, VerifyReceiptIOSRes>> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS);

  Future<Either<CustomFailure, String>> completeTransaction(
      {PurchasedItem item, String transactionId, bool isConsumable});

  Future<Either<CustomFailure, String?>> finalizeSubscription();

  Future<Either<CustomFailure, SubscriptionStateResponse>>
      getSubscriptionStatus(String productId);
}

class SubscriptionRepositoryImpl extends SubscriptionRepository {
  final SubscriptionDataSource dataSource;

  SubscriptionRepositoryImpl(this.dataSource);

  @override
  Future<Either<CustomFailure, List<IAPItem>>> getSubscriptionProducts(
      List<String> products) async {
    try {
      List<IAPItem> items = await dataSource.getSubscriptionProducts(products);
      return Right(items);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, Map<String, String>>>
      purchaseSubscriptionProduct(String productId,
          {bool isUpgrade = false}) async {
    try {
      Map<String, String> item = await dataSource
          .purchaseSubscriptionProduct(productId, isUpgrade: isUpgrade);
      return Right(item);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, VerifyReceiptAndroidRes>>
      verifyReceiptForAndroid(PurchaseReceiptAndroid purchaseReceiptAndroid,
          PurchasedItem purchasedItem) async {
    try {
      VerifyReceiptAndroidRes item = await dataSource.verifyReceiptForAndroid(
          purchaseReceiptAndroid, purchasedItem);
      return Right(item);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, VerifyReceiptIOSRes>> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS) async {
    try {
      VerifyReceiptIOSRes item =
          await dataSource.verifyReceiptForIOS(purchaseReceiptIOS);
      return Right(item);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, String>> completeTransaction(
      {PurchasedItem? item, String? transactionId, bool? isConsumable}) async {
    try {
      String completeMessage = await dataSource.completeTransaction(
          item: item, transactionId: transactionId, isConsumable: isConsumable);
      return Right(completeMessage);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, String?>> initializeSubscription() async {
    try {
      String? completeMessage = await dataSource.initializeSubscription();
      return Right(completeMessage);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, String?>> finalizeSubscription() async {
    try {
      String? completeMessage = await dataSource.finalizeSubscription();
      return Right(completeMessage);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, List<PurchasedItem>?>> getPastPurchases() async {
    try {
      List<PurchasedItem>? items = await dataSource.getPastPurchases();
      return Right(items);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, SubscriptionStateResponse>>
      getSubscriptionStatus(String productId) async {
    try {
      SubscriptionStateResponse result =
          await dataSource.getSubscriptionStatus(productId);
      return Right(result);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }

  @override
  Future<Either<CustomFailure, int>> checkSubscriptionReadyStatus() async {
    try {
      int result = await dataSource.checkSubscriptionReadyStatus();
      return Right(result);
    } on CustomFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomUnknownException(e.toString()));
    }
  }
}
