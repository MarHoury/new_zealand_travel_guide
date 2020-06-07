import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:new_zealand_travel_guide/attraction/popular_attraction_list_view.dart';
import 'package:new_zealand_travel_guide/attraction/attraction_detail_page.dart';
import 'package:new_zealand_travel_guide/attraction/nearby_attraction_list_view.dart';
import 'package:new_zealand_travel_guide/main.dart';
import 'package:flutter/material.dart';
import 'home_theme.dart';
import 'models/attraction.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  List<SearchResult> results = [];
  List<Attraction> popularAttractions = [];
  List<Attraction> nearbyAttractions = [];
  Position currentPosition;
  String detailPlaceId;
  String detailReference;

  @override
  void initState() {
    String apiKey = 'AIzaSyDVQyYIOmmXRMgyA_pQgCCsGr_iANHJbSA';
    googlePlace = GooglePlace(apiKey);

    getPopularAttractionsFromGoogle();
    getNearbyAttractionsFromGoogle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(),
                      getPopularAttractionsUI(),
                      Flexible(
                        child: getNearbyAttractionsUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPopularAttractionsUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Popular Attractions',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: HomeAppTheme.darkerText,
            ),
          ),
        ),
        PopularAttractionListView(
          callBack: (detailPlaceId, detailReference) {
            moveTo(detailPlaceId, detailReference);
          },
          popularAttractionList: popularAttractions,
        ),
      ],
    );
  }

  Widget getNearbyAttractionsUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nearby Attractions',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: HomeAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: NearbyAttractionListView(
              callBack: (detailPlaceId, detailReference) {
                moveTo(detailPlaceId, detailReference);
              },
              nearbyAttractionList: nearbyAttractions,
            ),
          )
        ],
      ),
    );
  }

  void moveTo(detailPlaceId, detailReference) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => AttractionDetailPage(placeId: detailPlaceId, reference: detailReference),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: HomeAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Where do you want to go?',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              autoCompleteSearch(value);
                            } else {
                              if (predictions.length > 0 && mounted) {
                                setState(() {
                                  predictions = [];
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 18, right: 18, bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'New Zealand',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: HomeAppTheme.grey,
                  ),
                ),
                Text(
                  'Travel Guide',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: HomeAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getPopularAttractionsFromGoogle() async {
    var result = await googlePlace.search.getTextSearch(
        'New Zealand point of interest',
        type: 'tourist_attraction');
    if (result != null && result.results != null && mounted) {
      setState(() {
        popularAttractions = result.results
            .map((e) => new Attraction(
                name: e.name,
                icon: e.icon,
                openNow:
                    (e.openingHours == null || e.openingHours.openNow == null)
                        ? false
                        : true,
                placeId: e.placeId,
                rating: e.rating,
                photoReference: (e.photos != null && e.photos.length > 0) ? e.photos[0].photoReference : ''))
            .toList();
      });
    }
  }

  void getNearbyAttractionsFromGoogle() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude), 10000,
        type: 'tourist_attraction');
    if (result != null && result.results != null && mounted) {
      setState(() {
        nearbyAttractions = result.results
            .map((e) => new Attraction(
                name: e.name,
                icon: e.icon,
                openNow:
                    (e.openingHours == null || e.openingHours.openNow == null)
                        ? false
                        : true,
                placeId: e.placeId,
                rating: e.rating,
                photoReference: (e.photos != null && e.photos.length > 0) ? e.photos[0].photoReference : ''))
            .toList();
      });
    }
  }

  void placeSearch(String query) async {
    var result = await googlePlace.search
        .getTextSearch(query, type: 'tourist_attraction');
    if (result != null && result.results != null && mounted) {
      setState(() {
        results = result.results;
      });
    }
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value + ' New Zealand');
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}
