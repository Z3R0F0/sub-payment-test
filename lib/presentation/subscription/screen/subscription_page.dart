import 'package:flutter/material.dart';
import 'package:cloudipsp_mobile_example/presentation/subscription/screen/subscription_screen.dart';

class SubscriptionPage extends StatelessWidget {
  static String tag = 'subscription-page';
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SubscriptionScreen());
  }
}
