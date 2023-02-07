import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';

class CardPaymentMethodList extends StatelessWidget {
  final String urlImages, name;
  final Function onTapMethod;
  const CardPaymentMethodList(
      {Key key, this.name, this.urlImages, this.onTapMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapMethod();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    child: name == 'PLAFON KOPKAR'
                        ? Image.asset(
                            'assets/images/logo_kopkar.png',
                            width: 80,
                            height: 20,
                          )
                        : urlImages.substring(urlImages.length - 3) == 'SVG'
                            ? SizedBox(
                                width: 80,
                                height: 20,
                                child: SvgPicture.network(
                                  urlImages,
                                  color: Color(0xff1A4C93),
                                ),
                              )
                            : Image.network(
                                urlImages,
                                width: 80,
                                height: 20,
                              )),
                SizedBox(
                  width: 12,
                ),
                Text(name)
              ],
            ),
            Divider(
              height: 5,
              color: ColorsCustom.generalText,
            )
          ],
        ),
      ),
    );
  }
}
