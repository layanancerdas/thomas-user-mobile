import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/vouchers/widgets/card_voucher.dart';
import 'package:tomas/widgets/custom_text.dart';
import './vouchers_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class VouchersView extends VouchersViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
          // elevation: 3,
          title: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? "Voucher Saya"
                : "My Vouchers",
            color: ColorsCustom.black,
          )),
      body: StoreConnector<AppState, GeneralState>(
          converter: (store) => store.state.generalState,
          builder: (context, state) {
            return SmartRefresher(
                controller: refreshController,
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: onRefresh,
                onLoading: onLoading,
                footer: ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 40),
                  itemCount: state.vouchers.length,
                  itemBuilder: (ctx, i) {
                    return CardVoucher(data: state.vouchers[i]);
                  },
                ));
          }),
      // body: ListView(
      //   children: [
      //     CardVoucher(),
      //     CardVoucher(),
      //   ],
      // )
    );
  }
}
