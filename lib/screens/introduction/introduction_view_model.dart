import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import './introduction.dart';

abstract class IntroductionViewModel extends State<Introduction> {
  List<PageViewModel> introductionId = [
    PageViewModel(
      titleWidget: CustomText(
        "Mulai Trip Anda",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "Untuk menikmati layanan AJK, silahkan kirim\npermintaan sebagai pengguna AJK dulu.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(1),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_one.svg",
      ),
    ),
    PageViewModel(
      titleWidget: CustomText(
        "Pesan Trip",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "Pilih AJK, pilih rute dan pilih titik penjemputan yang Anda inginkan.\nPesan paket trip untuk minggu depan.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(2),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_two.svg",
      ),
    ),
    PageViewModel(
      titleWidget: CustomText(
        "Nikmati Trip Anda",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "Lacak lokasi langsung driver shuttle Anda dengan mudah.\nHubungi kami melalui aplikasi jika terjadi sesuatu.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(3),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_three.svg",
      ),
    ),
  ];

  List<PageViewModel> introductionEn = [
    PageViewModel(
      titleWidget: CustomText(
        "Start Your Journey",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "To enjoy AJK service, please submit\na request as AJK user first.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(1),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_one.svg",
      ),
    ),
    PageViewModel(
      titleWidget: CustomText(
        "Book a Ride",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "Choose AJK, choose the route and choose your preferred pick up point.\nBook trip packages for next week.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(2),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_two.svg",
      ),
    ),
    PageViewModel(
      titleWidget: CustomText(
        "Enjoy Your Trip",
        color: ColorsCustom.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // title: "Enjoy Your Trip",
      bodyWidget: Column(
        children: [
          CustomText(
            "Easily track your shuttle driver's live location.\nContact us via app if something happens.",
            color: ColorsCustom.generalText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 85),
          dotsCustom(3),
        ],
      ),
      decoration: PageDecoration(
          imagePadding: EdgeInsets.zero, imageFlex: 1, bodyFlex: 1),
      image: SvgPicture.asset(
        "assets/images/introduction_three.svg",
      ),
    ),
  ];

  static Widget dotsCustom(int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: number == 1 ? ColorsCustom.primary : ColorsCustom.border,
              borderRadius: BorderRadius.circular(5)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: number == 2 ? ColorsCustom.primary : ColorsCustom.border,
              borderRadius: BorderRadius.circular(5)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: number == 3 ? ColorsCustom.primary : ColorsCustom.border,
              borderRadius: BorderRadius.circular(5)),
        )
      ],
    );
  }

  Future<void> onDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introduction', true);

    Navigator.pushReplacementNamed(context, '/Landing');
  }
}
