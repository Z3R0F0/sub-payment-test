import 'package:flutter/material.dart';
import 'package:cloudipsp_mobile_example/core/app_constants/my_string_constants.dart';
import 'package:cloudipsp_mobile_example/util/common_utils.dart';

class SubscriptionPlanView extends StatefulWidget {
  final bool isSelected;
  final String title;
  final String plan;
  final String planSubTitle;
  final int index;
  final Function(int) onTap;
  final bool isPlanDisable;
  const SubscriptionPlanView(
      {Key? key,
      required this.isSelected,
      required this.title,
      required this.plan,
      required this.planSubTitle,
      required this.index,
      required this.onTap,
      this.isPlanDisable = false})
      : super(key: key);

  @override
  State<SubscriptionPlanView> createState() => _SubscriptionPlanViewState();
}

class _SubscriptionPlanViewState extends State<SubscriptionPlanView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _subscriptionPlanView(widget.isSelected, widget.title, widget.plan,
        widget.planSubTitle, widget.index);
  }

  Widget _subscriptionPlanView(bool isSelected, String title, String plan,
          String planSubTitle, int index) =>
      InkWell(
        onTap: widget.isPlanDisable
            ? () {
                AppUtils.showShortToast(
                    context, StringConstant.activeSub);
              }
            : () {
                _onPlanViewTap(index);
              },
        child: _circularPlanView(isSelected, title, index, plan),
      );

  void _onPlanViewTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(_selectedIndex);
  }

  Widget _circularPlanView(
          bool isSelected, String title, int index, String plan) =>
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _planUpperView(title, isSelected),
            _planCenterView(plan),
          ],
        ),
      );

  Widget _planUpperView(String title, bool isSelected) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_off,
            color: isSelected ? Colors.red : Colors.grey,
          )
        ],
      );

  Widget _planCenterView(String plan) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          plan,

        ),
      );
}
