import 'package:http/http.dart' as http;
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_ios.dart';

class VerifyReceiptIOSRes {
  final PurchaseReceiptIOS purchaseReceiptIOS;
  final http.Response response;
  VerifyReceiptIOSRes(
      {required this.purchaseReceiptIOS, required this.response});
}
