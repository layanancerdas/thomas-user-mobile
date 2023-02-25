import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:redux/redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/actions/transaction_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/transaction_state.dart';
import 'package:tomas/localization/app_translations.dart';
import 'custom_text.dart';

class ModalPaymentMethod extends StatefulWidget {
  @override
  _ModalPaymentMethodState createState() => _ModalPaymentMethodState();
}

class _ModalPaymentMethodState extends State<ModalPaymentMethod> {
  Store<AppState> store;
  Map selectedPaymentMethod = {};

  bool isLoading = true;

  // List paymentMethod = [
  //   {"icon": 'ovo-single.png', "name": "OVO"},
  //   {"icon": 'gopay.png', "name": "GoPay"},
  //   {"icon": 'linkaja.png', "name": "LinkAja"},
  //   {"icon": 'shopeepay.png', "name": "ShopeePay"},
  //   {"icon": 'dana.png', "name": "DANA"},
  // ];

  void toggleSelectedPaymentMethod(Map value) {
    setState(() {
      selectedPaymentMethod = value;
    });
  }

  Future<void> onSave() async {
    await store.dispatch(
        SetSelectedPaymentMethod(selectedPaymentMethod: selectedPaymentMethod));
    Navigator.pop(context);
  }

  void initData() {
    if (!store.state.transactionState.selectedPaymentMethod
        .containsKey('name')) {
      selectedPaymentMethod = store.state.transactionState.paymentMethod[0];
    } else {
      selectedPaymentMethod =
          store.state.transactionState.selectedPaymentMethod;
    }
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, TransactionState>(
        converter: (store) => store.state.transactionState,
        builder: (context, state) {
          return Container(
            color: Colors.white.withOpacity(0.20),
            // padding: EdgeInsets.only(top: screenSize.height / 4),
            height: screenSize.height,
            child: Stack(
              children: [
                Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )),
                  padding: EdgeInsets.only(top: 38),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText(
                          "${AppTranslations.of(context).text("choose_payment")}",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: ColorsCustom.black,
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 6),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          children: state.paymentMethod
                              .map((e) => buttonPaymentMethod(
                                  context: context, data: e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    width: 32,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: ColorsCustom.generalText,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(3, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //   color: selectedPaymentMethod.containsKey('name')
                        //     ? ColorsCustom.primary
                        //     : ColorsCustom.disable,
                        // textColor: Colors.white,
                        elevation: 1,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => selectedPaymentMethod.containsKey('name')
                          ? onSave()
                          : {},
                      child: Text(
                        "${AppTranslations.of(context).text("save")}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white70,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Loading(
                            color: ColorsCustom.primary,
                            indicator: BallSpinFadeLoaderIndicator(),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          );
        });
  }

  Widget buttonPaymentMethod({BuildContext context, Map data}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: ColorsCustom.softGrey, width: 1))),
      child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 24),
          ),
          onPressed: () => toggleSelectedPaymentMethod(data),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        '${BASE_API + "/files/" + data['logo']}',
                        height: 24,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 12),
                    CustomText(
                      "${Utils.capitalizeFirstofEach(data['name'])}",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: ColorsCustom.black,
                      // textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                height: 24,
                width: 24,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 1,
                        color: data == selectedPaymentMethod
                            ? ColorsCustom.primary
                            : ColorsCustom.softGrey)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: data == selectedPaymentMethod
                        ? ColorsCustom.primary
                        : Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
