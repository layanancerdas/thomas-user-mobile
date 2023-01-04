import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardPlanTrip extends StatefulWidget {
  final Map data;
  final onClick;

  CardPlanTrip({this.data, this.onClick});

  @override
  _CardPlanTripState createState() => _CardPlanTripState();
}

class _CardPlanTripState extends State<CardPlanTrip> {
  String mode = '';
  double duration = 0;
  List pickupPoints = [];
  // double distance = 0;

  Future<void> getDuration() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best) ??
          await Geolocator.getLastKnownPosition();
      dynamic resCycling = await Providers.getDetailNavigation(
          origin: Location(lat: position.latitude, lng: position.longitude),
          destination: Location(
              lat: pickupPoints[0]['latitude'],
              lng: pickupPoints[0]['longitude']),
          mode: 'cycling');
      dynamic resWalking = await Providers.getDetailNavigation(
          origin: Location(lat: position.latitude, lng: position.longitude),
          destination: Location(
              lat: pickupPoints[0]['latitude'],
              lng: pickupPoints[0]['longitude']),
          mode: 'walking');

      if (resCycling.data['routes'][0]['duration'] <
          resWalking.data['routes'][0]['duration']) {
        setState(() {
          duration = resCycling.data['routes'][0]['duration'];
          // distance = resCycling.data['routes'][0]['distance'];
          mode = 'cycling';
        });
      } else {
        setState(() {
          duration = resWalking.data['routes'][0]['duration'];
          // distance = resWalking.data['routes'][0]['distance'];
          mode = 'walking';
        });
      }

      print(mode);
    } catch (e) {
      print(e);
    }
  }

  Future<void> filterPickupPoints() async {
    try {
      List _pickupPoints = widget.data['pickup_points'];
      _pickupPoints.sort((a, b) =>
          a['distance_from_passanger'].compareTo(b['distance_from_passanger']));

      if (mounted) {
        setState(() {
          pickupPoints = _pickupPoints;
        });
      }

      // print(mode);
    } catch (e) {
      print(e);
    } finally {
      await getDuration();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterPickupPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(blurRadius: 24, offset: Offset(0, 4), color: Colors.black12)
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 14, 0, 16),
          elevation: 0,
          // highlightColor: ColorsCustom.black.withOpacity(0.03),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => widget.onClick(widget.data, pickupPoints[0]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "AJK Shuttle",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: RichText(
                    text: new TextSpan(
                      text: 'Rp',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: ColorsCustom.primary,
                          fontFamily: 'Poppins'),
                      children: <TextSpan>[
                        new TextSpan(
                            text: pickupPoints.length > 0
                                ? Utils.currencyFormat
                                    .format(pickupPoints[0]['price'] * 10)
                                : "-"),
                        new TextSpan(
                            text: '/pkg',
                            style: TextStyle(
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorsCustom.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      text:
                          '${pickupPoints.length > 0 ? pickupPoints[0]['time_to_dest'] : "-"}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'Poppins'),
                      children: <TextSpan>[
                        new TextSpan(
                            text: '\nMins',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 9,
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 14, bottom: 14, right: 16),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: ColorsCustom.border))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: CustomText(
                          "${pickupPoints.length > 0 ? pickupPoints[0]['name'] : "-"}",
                          color: ColorsCustom.black,
                          overflow: true,
                        ),
                      ),
                      Container(
                        width: 30,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: SvgPicture.asset('assets/images/arrow.svg'),
                      ),
                      Flexible(
                        child: CustomText(
                          "${widget.data['destination_name'] ?? '-'}",
                          color: ColorsCustom.black,
                          overflow: true,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                SizedBox(width: 14),
                mode == 'cycling'
                    ? SvgPicture.asset(
                        'assets/images/motorcycle.svg',
                        height: 26,
                      )
                    : SvgPicture.asset(
                        'assets/images/walk.svg',
                        height: 26,
                      ),
                SizedBox(width: 8),
                CustomText(
                  "${(duration ~/ 60).round()} Mins",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    'assets/images/chevron-right.svg',
                    height: 16,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/school_bus.svg',
                  height: 26,
                  width: 26,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(right: 16),
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    "${AppTranslations.of(context).text("5_days")}",
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
