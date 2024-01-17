import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloudipsp_mobile_example/core/app_constants/app_constants.dart';
import 'package:cloudipsp_mobile_example/core/app_constants/app_params.dart';
import 'package:cloudipsp_mobile_example/core/app_constants/screen_size_config.dart';
import 'package:cloudipsp_mobile_example/core/app_constants/my_string_constants.dart';
import 'package:cloudipsp_mobile_example/core/util/preference_manager.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/bloc/subscription_event.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/bloc/subscription_state.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/screen/subscription_page.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/widgets/subscription_plan_view.dart';
import 'package:cloudipsp_mobile_example/widgets/my_button.dart';

import 'package:cloudipsp_mobile_example/util/common_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import "package:http/http.dart" as http;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 0;
  SubscriptionBloc? _subscriptionBloc;
  List<IAPItem> _subscriptionItems = [];
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  final List<PurchasedItem> _pastPurchases = [];
  final ScrollController _scrollController = ScrollController();
  String accessToken = "";
  bool _isRestoredEnable = false;
  bool _isNextEnable = false;
  bool _isProgressDone = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _subscriptionBloc = BlocProvider.of<SubscriptionBloc>(context);
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
      await _getDetailsToVerifyPurchaseOnAndroid();
    });
  }

  Future _getDetailsToVerifyPurchaseOnAndroid() async {
    if (Platform.isAndroid) {
      AccessCredentials credentials = await obtainCredentials();
      setState(() {
        accessToken = credentials.accessToken.data;
      });
    }
  }

  Future<AccessCredentials> obtainCredentials() async {
    var accountCredentials = ServiceAccountCredentials.fromJson({
      AppParams.prKeyId: "<private key id from secure space>",
      AppParams.prKey: "<private key from secure space>",
      AppParams.clientEmail: "<client email from secure space>",
      AppParams.clientId: "<client id from secure space>",
      AppParams.type: "<type from secure space>",
    });
    var scopes = [MyConstants.verifyingScope];

    var client = http.Client();
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            accountCredentials, scopes, client);

    client.close();
    return credentials;
  }

  @override
  void dispose() async {
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription?.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription?.cancel();
      _purchaseErrorSubscription = null;
    }
    _subscriptionBloc?.add(FinalizeSubscriptionEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return _subscriptionView(context);
  }

  Widget _subscriptionView(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
            listener: (context, state) {
              _subscriptionStateWiseMethod(context, state);
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chooseSubscriptionView(),
                    _extraHeight(context, 15),
                    if (_subscriptionItems.isNotEmpty && _isProgressDone)
                      _subscriptionPlanList(context, state)
                    else
                      _indicatingLoader(),
                    _extraHeight(context, 15),
                    _nextBtn(context, state),
                    _restoreBtn(context),
                  ],
                ),
              );
            },
          ),
        ),
      );

  Widget _chooseSubscriptionView() => Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          StringConstant.subPlans,
        ),
      );

  Widget _extraHeight(BuildContext context, double value) =>
      SizedBox(height: ScreenSizeConfig.getScaledValue(value, context));

  Widget _subscriptionPlanList(BuildContext context, SubscriptionState state) =>
      ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  index == 0 ? EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
              child: SubscriptionPlanView(
                  isSelected: _selectedIndex == (index + 1),
                  title: Platform.isIOS
                      ? _subscriptionItems[index].title ?? ""
                      : _subscriptionItems[index].title?.substring(0, 12) ?? "",
                  plan: ((_subscriptionItems[index].localizedPrice ?? "")
                          .toUpperCase()) +
                      _getRatePerMonthYear(index),
                  planSubTitle:
                      ((_subscriptionItems[index].localizedPrice ?? "")
                              .toUpperCase()) +
                          _getPerMonthYear(index),
                  index: (index + 1),
                  isPlanDisable: _isRestoredEnable,
                  onTap: (index) {
                    if (state is PurchaseSubscriptionProductLoading == false) {
                      _onPlanViewTap(index);
                    }
                  }),
            );
          },
          itemCount: _subscriptionItems.length);

  String _getRatePerMonthYear(int index) => index == 0 ? "/месяц" : "/год";

  String _getPerMonthYear(int index) => index == 0 ? "/месяц" : "/год";

  Widget _indicatingLoader() => SizedBox(
        height: ScreenSizeConfig.screenHeight * 0.3,
        child: const Center(child: CircularProgressIndicator()),
      );

  Widget _nextBtn(BuildContext context, SubscriptionState state) {
    if (state is PurchaseSubscriptionProductLoading) {
      return _btnWithLoading(context);
    } else {
      return _btnWithLabel(context);
    }
  }

  Widget _btnWithLoading(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            ),
          ),
          onPressed: null,
          child: const CircularProgressIndicator(),
        ),
      );

  Widget _btnWithLabel(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: MyButton(
            text: "Далее",
            onPressed: _selectedIndex != 0 && _isNextEnable == true
                ? () {
                    _purchaseSubscriptionProduct(context);
                  }
                : null,
            textColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.white
                : Colors.black,
            backgroundColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.red
                : Colors.black),
      );

  Widget _restoreBtn(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: MyButton(
            text: "Вернуть подписки",
            onPressed: _isRestoredEnable
                ? () {
                    _onRestoreTap(context);
                  }
                : null,
            textColor: _isRestoredEnable ? Colors.white : Colors.black,
            backgroundColor: _isRestoredEnable ? Colors.red : Colors.green),
      );

  void _onRestoreTap(BuildContext context) {
    //You can save plan detail in your preference
    AppUtils.showShortToast(context, StringConstant.restoredPlan);
  }

  void _subscriptionStateWiseMethod(
      BuildContext context, SubscriptionState state) async {
    if (state is InitializeSubscriptionSuccess) {
      _subscriptionBloc?.add(CheckSubscriptionReadyStatusEvent());
    } else if (state is InitializeSubscriptionFailure) {
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
    } else if (state is CheckSubscriptionReadyStatusSuccess) {
      _getSubscriptionProducts();
    } else if (state is CheckSubscriptionReadyStatusFailure) {
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
    } else if (state is GetSubscriptionProductsSuccess) {
      _updateSubscriptionProductAndGetPastPurchase(state);
    } else if (state is GetSubscriptionProductsFailure) {
      AppUtils.showShortToast(context, state.errorMessage);
    } else if (state is GetPastPurchasesSuccess) {
      _addPurchaseItems(state);
    } else if (state is GetPastPurchasesFailure) {
      AppUtils.showShortToast(context, state.errorMessage);
    } else if (state is PurchaseSubscriptionProductFailure) {
      debugPrint(state.errorMessage);
    } else if (state is VerifyPurchaseAndroidSuccess) {
      _completeAndroidTransaction(state);
    } else if (state is VerifyPurchaseAndroidFailure) {
      AppUtils.showShortToast(context, state.errorMessage);
    } else if (state is VerifyPurchaseIOSSuccess) {
      _completeIOSTransaction(state);
    } else if (state is VerifyPurchaseIOSFailure) {
      AppUtils.showShortToast(context, state.errorMessage);
    } else if (state is CompleteTransactionSuccess) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
      if (ModalRoute.of(context)?.settings.name == SubscriptionPage.tag ||
          ModalRoute.of(context)?.settings.name == "/") {
        if (Platform.isIOS) {
          if (PreferenceManager.isBottomSheetVisible() == true) {
            _showBottomSheet(context);
          }
        } else {
          _showBottomSheet(context);
        }
      }
    } else if (state is CompleteTransactionFailure) {
      AppUtils.showShortToast(context, state.errorMessage);
    } else if (state is PurchaseSubscriptionProductStopLoading) {
      if (Platform.isIOS) {
        PreferenceManager.setBottomSheetVisibility(false);
      }
    } else {
      debugPrint("Error not required");
    }
  }

  void _getSubscriptionProducts() async {
    await _listenPurchaseStreams();
    _subscriptionBloc?.add(const GetSubscriptionProductsEvent(
        productIds: [MyConstants.monthlySub, MyConstants.yearlySub]));
    await FlutterInappPurchase.instance.initialize();
    bool isMonthlyActive = await FlutterInappPurchase.instance
        .checkSubscribed(sku: MyConstants.monthlySub);
    bool isYearlyActive = await FlutterInappPurchase.instance
        .checkSubscribed(sku: MyConstants.yearlySub);
    if (isMonthlyActive || isYearlyActive) {
      setState(() {
        _isRestoredEnable = true;
      });
    }
    setState(() {
      _isNextEnable = !_isRestoredEnable;
      _isProgressDone = true;
    });
    if (Platform.isIOS) {
      if (_isRestoredEnable == true) {
        PreferenceManager.setBottomSheetVisibility(false);
      }
    }
  }

  void _updateSubscriptionProductAndGetPastPurchase(
      GetSubscriptionProductsSuccess state) {
    setState(() {
      if (state.iapItems.isNotEmpty) {
        _subscriptionItems = List.from(state.iapItems);
      } else {
        _subscriptionItems = [];
      }
    });
  }

  void _addPurchaseItems(GetPastPurchasesSuccess state) {
    for (var item in state.purchasedItems) {
      setState(() {
        _pastPurchases.add(item);
      });
    }
  }

  void _completeAndroidTransaction(VerifyPurchaseAndroidSuccess state) {
    if (state.verifyReceiptAndroidRes.response.statusCode == 200) {
      if (Platform.isAndroid) {
        _subscriptionBloc?.add(CompleteTransactionEvent(
            purchasedItem: state.verifyReceiptAndroidRes.purchasedItem,
            isConsumable: false));
      }
    }
  }

  void _completeIOSTransaction(VerifyPurchaseIOSSuccess state) {
    if (state.verifyReceiptIOSRes.response.statusCode == 200) {
      if (Platform.isIOS) {
        _subscriptionBloc?.add(CompleteTransactionEvent(
            transactionId: state.verifyReceiptIOSRes.purchaseReceiptIOS
                    .receiptBody[AppParams.transactionId] ??
                ""));
      }
    }
  }

  Future<void> _listenPurchaseStreams() async {
    if (!mounted) return;
    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((error) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
    });
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (productItem != null) {
        if (Platform.isIOS) {
          if (productItem.transactionStateIOS == TransactionState.purchasing) {
            debugPrint('purchase:purchasing');
          } else if (productItem.transactionStateIOS ==
              TransactionState.failed) {
            debugPrint('purchase-error:');
          } else if (productItem.transactionStateIOS ==
              TransactionState.purchased) {
            debugPrint('purchase-purchased:');
            _verifyIOSReceipt(productItem);
          } else if (productItem.transactionStateIOS ==
              TransactionState.restored) {
            debugPrint('purchase-restored:');
          } else if (productItem.transactionStateIOS ==
              TransactionState.deferred) {
            debugPrint('A transaction that is in the queue');
          } else {
            debugPrint('not required');
          }
        } else {
          if (productItem.purchaseStateAndroid == PurchaseState.pending) {
            debugPrint('purchase:pending');
          } else if (productItem.purchaseStateAndroid ==
              PurchaseState.unspecified) {
            debugPrint('purchase-unspecified:');
          } else if (productItem.purchaseStateAndroid ==
              PurchaseState.purchased) {
            debugPrint('purchase-purchased:');
            _verifyAndroidReceipt(productItem);
          } else {
            debugPrint('purchase-failed:');
          }
        }
      }
    }, onDone: () {
      _purchaseUpdatedSubscription?.cancel();
    }, onError: (purchaseError) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
    });
  }

  void _verifyIOSReceipt(PurchasedItem productItem) {
    PurchaseReceiptIOS purchaseReceiptIOS = PurchaseReceiptIOS(receiptBody: {
      AppParams.receiptData: productItem.transactionReceipt ?? "",
      AppParams.password: "<app-specific-shared-secret>"
    }, isTest: false);
    _subscriptionBloc
        ?.add(VerifyReceiptIOSEvent(purchaseReceiptIOS: purchaseReceiptIOS));
  }

  void _verifyAndroidReceipt(PurchasedItem productItem) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    PurchaseReceiptAndroid purchaseReceiptAndroid = PurchaseReceiptAndroid(
        packageName: packageInfo.packageName,
        productId: productItem.productId ?? "",
        productToken: productItem.purchaseToken ?? "",
        accessToken: accessToken,
        isSubscription: true);
    _subscriptionBloc?.add(VerifyReceiptAndroidEvent(
        purchaseReceiptAndroid: purchaseReceiptAndroid,
        purchasedItem: productItem));
  }

  void _showBottomSheet(BuildContext context) {
    if (Platform.isIOS) {
      PreferenceManager.setBottomSheetVisibility(false);
    }
    AppUtils.showShortToast(context, StringConstant.purchaseSuccessfully);
  }

  void _purchaseSubscriptionProduct(BuildContext context) {
    _subscriptionBloc
        ?.add(const PurchaseSubscriptionProductLoadingEvent(isLoading: true));
    _subscriptionBloc?.add(PurchaseSubscriptionProductEvent(
        productId: _subscriptionItems[_selectedIndex - 1].productId ?? "",
        isUpgrade: false));
    if (Platform.isIOS) {
      PreferenceManager.setBottomSheetVisibility(true);
    }
  }

  void _onPlanViewTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
