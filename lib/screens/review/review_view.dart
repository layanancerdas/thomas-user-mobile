import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './review_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class ReviewView extends ReviewViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            leading: TextButton(
              style: TextButton.styleFrom(),
              onPressed: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/images/close-red.svg',
              ),
            ),
            title: CustomText(
              "${AppTranslations.of(context).text("give_a_review")}",
              color: ColorsCustom.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          body: StoreConnector<AppState, UserState>(
              converter: (store) => store.state.userState,
              builder: (context, state) {
                return Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.only(top: 16, bottom: 70),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: ColorsCustom.primaryVeryLow
                                            .withOpacity(0.64),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: SvgPicture.asset(
                                      'assets/images/school_bus.svg',
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            "${state.selectedMyTrip['pickup_point']['name'] ?? "-"}",
                                            color: ColorsCustom.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          Container(
                                            width: 30,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: SvgPicture.asset(
                                                'assets/images/arrow.svg'),
                                          ),
                                          CustomText(
                                            "${state.selectedMyTrip['trip']['trip_group']['route']['destination_name'] ?? "-"}",
                                            color: ColorsCustom.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                      CustomText(
                                        "${state.selectedMyTrip['details']['bus']['brand'] ?? "-"}: ${state.selectedMyTrip['details']['bus']['license_plate'] ?? "-"}",
                                        color: ColorsCustom.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                          SizedBox(height: valueReview == 5 ? 42 : 40),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/star-${valueReview == 0 ? 5 : valueReview}.svg',
                                height: valueReview == 5 ? 60 : 64,
                                width: valueReview == 5 ? 60 : 64,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: valueReview == 5 ? 26 : 24,
                                    bottom: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    starReview(1, valueReview >= 1),
                                    starReview(2, valueReview >= 2),
                                    starReview(3, valueReview >= 3),
                                    starReview(4, valueReview >= 4),
                                    starReview(5, valueReview >= 5),
                                  ],
                                ),
                              ),
                              valueReview > 0
                                  ? CustomText(
                                      "${AppTranslations.of(context).currentLanguage == 'id' ? StaticTextId.nameByStar[valueReview - 1] : StaticTextEn.nameByStar[valueReview - 1]}",
                                      color: ColorsCustom.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    )
                                  : SizedBox(height: 21),
                              SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: valueReview >= 3
                                      ? AppTranslations.of(context)
                                                  .currentLanguage ==
                                              'id'
                                          ? StaticTextId.fastMoreResponse
                                              .map((e) => buttonFastResponse(e))
                                              .toList()
                                          : StaticTextEn.fastMoreResponse
                                              .map((e) => buttonFastResponse(e))
                                              .toList()
                                      : AppTranslations.of(context)
                                                  .currentLanguage ==
                                              'id'
                                          ? StaticTextId.fastLessResponse
                                              .map((e) => buttonFastResponse(e))
                                              .toList()
                                          : StaticTextEn.fastLessResponse
                                              .map((e) => buttonFastResponse(e))
                                              .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Container(
                            height: 5 * 24.0,
                            margin: const EdgeInsets.all(16),
                            child: TextFormField(
                              controller: descController,
                              onTap: () => onDescTap(),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 5,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                hintText:
                                    "${AppTranslations.of(context).text("tell_us")}",
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsCustom.softGrey, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsCustom.primary, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    StoreConnector<AppState, GeneralState>(
                        converter: (store) => store.state.generalState,
                        builder: (context, stateGeneral) {
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom ==
                                          0
                                      ? 10
                                      : 10),
                              child: CustomButton(
                                text:
                                    "${AppTranslations.of(context).text("send")}",
                                textColor: Colors.white,
                                bgColor: ColorsCustom.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                onPressed: () =>
                                    stateGeneral.isLoading ? {} : onSubmit(),
                              ),
                            ),
                          );
                        })
                  ],
                );
              })),
    );
  }

  Widget starReview(int value, bool condition) {
    return GestureDetector(
      onTap: () => toggleValueReview(value),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: SvgPicture.asset(
          'assets/images/star_${condition ? 'filled' : 'outline'}.svg',
          height: 42,
          width: 40,
        ),
      ),
    );
  }

  Widget buttonFastResponse(String value) {
    return GestureDetector(
      onTap: () => toggleFastResponse(value),
      child: Container(
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
        decoration: BoxDecoration(
            color: valueFastResponse.contains(value)
                ? ColorsCustom.primary
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: valueFastResponse.contains(value)
                ? Border.all(width: 1, color: Colors.transparent)
                : Border.all(width: 1, color: ColorsCustom.softGrey)),
        child: CustomText(
          "$value",
          color: valueFastResponse.contains(value)
              ? Colors.white
              : ColorsCustom.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
