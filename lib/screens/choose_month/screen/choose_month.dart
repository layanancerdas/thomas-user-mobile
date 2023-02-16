// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
// import 'package:loading/loading.dart';
// import 'package:tomas/helpers/colors_custom.dart';
// import 'package:tomas/helpers/utils.dart';
// import 'package:tomas/localization/app_translations.dart';
// import 'package:tomas/redux/app_state.dart';
// import 'package:tomas/redux/modules/ajk_state.dart';
// import 'package:tomas/screens/choose_month/widget/list_subcription.dart';
// import 'package:tomas/widgets/alert_permit.dart';
// import 'package:tomas/widgets/custom_text.dart';

// class ChooseMonth extends StatefulWidget {
//   const ChooseMonth({Key key}) : super(key: key);

//   @override
//   State<ChooseMonth> createState() => _ChooseMonthState();
// }

// class _ChooseMonthState extends State<ChooseMonth> {
//   @override
//   bool isSelected = false;
//   void radioButtonChanges(String value, bool val) {
//     setState(() {
//       switch (value) {
//         case '1':
//           isSelected = true;
//           break;
//         default:
//           isSelected = false;
//       }
//     });
//   }

//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, AjkState>(
//         converter: (store) => store.state.ajkState,
//         builder: (context, state) {
//           return Scaffold(
//               appBar: AppBar(
//                 leading: TextButton(
//                   style: TextButton.styleFrom(),
//                   onPressed: () => Navigator.pop(context),
//                   child: SvgPicture.asset(
//                     'assets/images/back_icon.svg',
//                   ),
//                 ),
//                 // elevation: 3,
//                 centerTitle: true,
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: CustomText(
//                           "${Utils.capitalizeFirstofEach(state.selectedPickUpPoint['name']) ?? "-"}",
//                           color: ColorsCustom.black,
//                           overflow: true,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 30,
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       child: SvgPicture.asset('assets/images/exchange.svg'),
//                     ),
//                     Expanded(
//                       child: CustomText(
//                         "${Utils.capitalizeFirstofEach(state.selectedRoute['destination_name']) ?? "-"}",
//                         color: ColorsCustom.black,
//                         overflow: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 actions: [SizedBox(width: 50)],
//               ),
//               body: Stack(
//                 children: [
//                   ListView(padding: EdgeInsets.all(20), children: [
//                     AlertPermit(),
//                     SizedBox(height: 5),
//                     CustomText(
//                       'Pilih Durasi Subscription',
//                       color: ColorsCustom.black,
//                       fontSize: 14,
//                     ),
//                     ListSubcription(
//                       value: '1',
//                     ),
//                     ListSubcription(
//                       value: '2',
//                     ),
//                     ListSubcription(
//                       value: '3',
//                     ),
//                     ListSubcription(
//                       value: '4',
//                     )
//                   ]),
//                   // ),
//                 ],
//               ));
//         });
//   }
// }
