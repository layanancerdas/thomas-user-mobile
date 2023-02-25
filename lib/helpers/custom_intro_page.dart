import 'package:flutter/material.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:introduction_screen/src/ui/intro_content.dart';

class CustomIntroPage extends StatelessWidget {
  final PageViewModel page;

  const CustomIntroPage({Key key, @required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: page.decoration.pageColor,
      decoration: page.decoration.boxDecoration,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (page.image != null)
              Expanded(
                flex: page.decoration.imageFlex,
                child: Column(
                  children: [
                    Container(
                        height: screenSize.height / 2,
                        padding: EdgeInsets.only(top: 30),
                        alignment: Alignment.bottomCenter,
                        child: page.image),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: IntroContent(page: page),
                      ),
                    ),
                  ],
                ),
              ),
            // Expanded(
            //   flex: page.decoration.bodyFlex,
            //   child:
            // ),
          ],
        ),
      ),
    );
  }
}
