import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:weather/weather_library.dart';
import 'home_theme.dart';
import 'models/attraction_detail.dart';

class AttractionDetailPage extends StatefulWidget {
  const AttractionDetailPage(
      {Key key, this.placeId, this.photoReference, this.googlePlace})
      : super(key: key);

  final String placeId;
  final String photoReference;
  final GooglePlace googlePlace;

  @override
  _AttractionDetailPageState createState() => _AttractionDetailPageState(
      this.placeId, this.photoReference, this.googlePlace);
}

class _AttractionDetailPageState extends State<AttractionDetailPage>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  final String placeId;
  final String photoReference;
  final GooglePlace googlePlace;

  _AttractionDetailPageState(
      this.placeId, this.photoReference, this.googlePlace);

  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  AttractionDetail attractionDetail;
  Uint8List photo;
  String weatherApiKey = 'd8c88fc2e193b1616502b9d12e1949b1';
  WeatherStation ws;
  Weather weather;

  @override
  void initState() {
    ws = new WeatherStation(weatherApiKey);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();

    getAttractionDetailFromGoogle();

    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: HomeAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: (photoReference != null && photoReference != '')
                      ? Image.network(
                          'https://maps.googleapis.com/maps/api/place/photo?photoreference=' +
                              photoReference +
                              '&sensor=false&maxheight=500&maxwidth=600&key=AIzaSyDVQyYIOmmXRMgyA_pQgCCsGr_iANHJbSA',
                          fit: BoxFit.cover,
                        )
                      : (photo != null
                          ? Image.memory(
                              photo,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/attraction/webInterFace.png')),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 40.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: HomeAppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: HomeAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              attractionDetail != null
                                  ? attractionDetail.name
                                  : 'Name',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: HomeAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  (attractionDetail != null &&
                                          attractionDetail.userRatingsTotal !=
                                              null)
                                      ? ('User Ratings Total: ' +
                                          attractionDetail.userRatingsTotal
                                              .toString())
                                      : '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: HomeAppTheme.nearlyBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        (attractionDetail != null &&
                                                attractionDetail.rating != null)
                                            ? attractionDetail.rating.toString()
                                            : '0.0',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: HomeAppTheme.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: HomeAppTheme.nearlyBlue,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI(
                                      attractionDetail != null
                                          ? attractionDetail.openNow.toString()
                                          : 'N/A',
                                      'Open Now'),
                                  getTimeBoxUI(
                                      attractionDetail != null
                                          ? attractionDetail.priceLevel
                                          : 'N/A',
                                      'Price Level'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  attractionDetail != null
                                      ? ('Website: ' +
                                          attractionDetail.website +
                                          '\n\n' +
                                          'Phone: ' +
                                          attractionDetail
                                              .formattedPhoneNumber +
                                          '\n\n' +
                                          'Address: ' +
                                          attractionDetail.formattedAddress)
                                      : 'N/A',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    letterSpacing: 0.27,
                                    color: HomeAppTheme.grey,
                                  ),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: HomeAppTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Center(
                        child: SimpleTooltip(
                      animationDuration: Duration(seconds: 3),
                      show: true,
                      tooltipDirection: TooltipDirection.up,
                      ballonPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      arrowLength: 0,
                      arrowTipDistance: 10,
                      minWidth: 130,
                      minHeight: 75,
                      child: weather != null
                          ? Image.network('http://openweathermap.org/img/w/' +
                              weather.weatherIcon +
                              '.png')
                          : Icon(
                              Icons.favorite,
                              color: HomeAppTheme.nearlyWhite,
                              size: 30,
                            ),
                      content: Text(
                        weather != null
                            ? (weather.weatherDescription + '\n\nTemperature: ' +
                                weather.temperature.celsius.toStringAsFixed(0) +
                                '℃\nHumidity: ' +
                                weather.humidity.toStringAsFixed(0) +
                                '\nWind Speed: ' +
                                weather.windSpeed.toStringAsFixed(0) +
                                'km/h')
                            : 'Loading...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: HomeAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: HomeAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HomeAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: HomeAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: HomeAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAttractionDetailFromGoogle() async {
    var result = await googlePlace.details.get(this.placeId,
        fields:
            'name,formatted_address,formatted_phone_number,rating,website,photo,opening_hours,price_level,user_ratings_total,geometry');
    if (result != null && result.result != null && mounted) {
      setState(() {
        attractionDetail = AttractionDetail(
            name: result.result.name,
            formattedAddress: result.result.formattedAddress != null
                ? result.result.formattedAddress
                : 'N/A',
            formattedPhoneNumber: result.result.formattedPhoneNumber != null
                ? result.result.formattedPhoneNumber
                : 'N/A',
            rating: result.result.rating,
            website:
                result.result.website != null ? result.result.website : 'N/A',
            openNow: result.result.openingHours != null
                ? result.result.openingHours.openNow.toString()
                : 'N/A',
            priceLevel: getPriceLevelDisplay(result.result.priceLevel),
            userRatingsTotal: result.result.userRatingsTotal);
      });

      if ((photoReference == null || photoReference == '') &&
          result.result.photos != null) {
        getAttractionPhotosFromGoogle(result.result.photos[0].photoReference);
      }

      if (result.result.geometry != null) {
        getCurrentWeather(result.result.geometry.location.lat,
            result.result.geometry.location.lng);
      }
    }
  }

  String getPriceLevelDisplay(code) {
    switch (code) {
      case 0:
        return 'Free';
        break;
      case 1:
        return 'Inexpensive';
        break;
      case 2:
        return 'Moderate';
        break;
      case 3:
        return 'Expensive';
        break;
      case 4:
        return 'Very Expensive';
        break;
      default:
        return 'N/A';
    }
  }

  void getAttractionPhotosFromGoogle(String photoReference) async {
    Uint8List result = await googlePlace.photos.get(photoReference, 600, 600);
    if (result != null && mounted) {
      setState(() {
        photo = result;
      });
    }
  }

  void getCurrentWeather(double lat, double lng) async {
    Weather result = await ws.currentWeather(lat, lng);
    if (result != null) {
      setState(() {
        weather = result;
      });
    }
  }
}
