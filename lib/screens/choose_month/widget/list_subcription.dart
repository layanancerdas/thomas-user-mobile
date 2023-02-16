// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:tomas/helpers/colors_custom.dart';
// import 'package:tomas/widgets/custom_text.dart';

// class ListSubcription extends StatelessWidget {
//   final String value;
//   final bool isSelected;
//   const ListSubcription({Key key, this.value, this.isSelected})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 12),
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(width: 1, color: ColorsCustom.newGrey)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CustomText(
//                 '1 Month',
//                 color: ColorsCustom.primary,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               SvgPicture.asset(
//                 'assets/images/vertical_divider.svg',
//                 color: ColorsCustom.black,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               CustomText(
//                 '01/02/2023 - 28/02/2023',
//                 color: ColorsCustom.black,
//                 fontSize: 12,
//               ),
//             ],
//           ),
//           Container(
//             width: 24,
//             height: 24,
//             padding: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(width: 8, color: ColorsCustom.primary)),
//           )
//         ],
//       ),
//     );
//   }
// }
