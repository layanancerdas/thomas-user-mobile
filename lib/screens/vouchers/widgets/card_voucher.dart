import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/vouchers/widgets/modal_voucher_terms.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardVoucher extends StatefulWidget {
  final Map data;

  CardVoucher({this.data});

  @override
  _CardVoucherState createState() => _CardVoucherState();
}

class _CardVoucherState extends State<CardVoucher> {
  Store<AppState> store;
  bool statusApply = false;
  bool statusUsed = false;

  Future<void> toggleStatusApply() async {
    setState(() {
      statusApply = !statusApply;
    });
    await store.dispatch(SetSelectedVoucher(selectedVoucher: widget.data));
    Navigator.pop(context);
  }

  void onTermAndConditions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalVoucherTerms(data: widget.data);
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final bool firstValid = DateTime.now().isAfter(
    //     DateTime.fromMillisecondsSinceEpoch(
    //         int.parse(widget.data['first_valid'])));
    final bool lastValid = DateTime.now().isBefore(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(widget.data['last_valid'])));

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(minHeight: 155),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                  blurRadius: 14,
                  color: ColorsCustom.black.withOpacity(0.12))
            ]),
        child: StoreConnector<AppState, GeneralState>(
            converter: (store) => store.state.generalState,
            builder: (context, state) {
              return Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: 155),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(minHeight: 155),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: ColorsCustom.primaryGreen,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    )),
                                child: Center(
                                  child:
                                      // RotationTransition(
                                      //     turns: new AlwaysStoppedAnimation(90 / 360),
                                      CustomText(
                                    "${Utils.capitalizeFirstofEach(widget.data['name'])}",
                                    // "FREE\nRIDE",
                                    textAlign: TextAlign.center,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: -1.5,
                                child: SvgPicture.asset(
                                  "assets/images/dashline.svg",
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Discount ${widget.data['discount_type'] == "AMOUNT" ? "Rp" + Utils.currencyFormat.format(widget.data['discount_amount']) : (widget.data['discount_percentage'] * 100).toString() + "%"} AJK",
                                    fontSize: 12,
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    "Min spend Rp0",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorsCustom.black,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    "Valid till ${Utils.formatterDateGeneral.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.data['last_valid'])))}",
                                    fontSize: 12,
                                    color: ColorsCustom.generalText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => onTermAndConditions(),
                                        child: SizedBox(
                                          width: 60,
                                          child: CustomText(
                                            "${AppTranslations.of(context).text("readtc")}",
                                            fontSize: 12,
                                            color: Color(0xFF5BB2C9),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      state.selectedVouchers['voucher_id'] ==
                                              widget.data['voucher_id']
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: ColorsCustom
                                                      .primaryVeryLow,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: CustomText(
                                                AppTranslations.of(context)
                                                            .currentLanguage ==
                                                        'id'
                                                    ? "Dipakai"
                                                    : "Applied",
                                                color: ColorsCustom.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : !lastValid
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          ColorsCustom.softGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: CustomText(
                                                    AppTranslations.of(context)
                                                                .currentLanguage ==
                                                            'id'
                                                        ? "Kadaluarsa"
                                                        : "Expired",
                                                    color: ColorsCustom
                                                        .generalText,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: 70,
                                                  height: 30,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      //       color: ColorsCustom.primary,
                                                      // borderSide: BorderSide(
                                                      //     color: ColorsCustom
                                                      //         .primary,
                                                      //     width: 1),
                                                      padding: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                    ),
                                                    onPressed: () =>
                                                        toggleStatusApply(),
                                                    child: CustomText(
                                                      AppTranslations.of(
                                                                      context)
                                                                  .currentLanguage ==
                                                              'id'
                                                          ? "Pakai"
                                                          : "Use",
                                                      color:
                                                          ColorsCustom.primary,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: -12,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: -12,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12)),
                        )),
                  )
                ],
              );
            }));
  }
}
