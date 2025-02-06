import 'dart:async';
import 'dart:math';

import 'package:cvsr/dataSearch.dart';
import 'package:cvsr/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  getCurrentLocationApp() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    print("==============================");
    print(position.latitude);
    print(position.longitude);
    print("==============================");

    return position;
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool disenable = true;

  void _onMapTapped(_currentLoation) {
    // Show an AlertDialog when any point on the map is tapped
    if (disenable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              backgroundColor: Colors.white,
              elevation: 10,
              title: Text(
                "GPS Warning!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "os-bold",
                    fontSize: 18,
                    color: Color.fromARGB(255, 247, 48, 21)),
              ),
              content: Text(
                "Please activate your GPS to measure the distance between your location and the store. ",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: "os-reg",
                    fontSize: 15,
                    color: Color(0xff333333)),
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 242, 239, 239)),
                    shadowColor: WidgetStateProperty.all(Color(0xffcccccc)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK",
                      style: TextStyle(
                        fontFamily: "os-bold",
                        fontSize: 14,
                        color: Colors.blue,
                      )),
                ),
              ],
            ),
          );
        },
      );
    } else {}
  }

  String distance(double lat1, double long1, double lat2, double long2) {
    double distanceINmeters =
        Geolocator.distanceBetween(lat1, long1, lat2, long2);
    double distance = distanceINmeters / 1000;
    String numberStr = distance.toString();

    // Remove trailing zeros in case of decimal representation

    // Take the first four digits
    String firstFour = numberStr.substring(0, 4);

    return firstFour;
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.7128, -74.0060),
    zoom: 14.0,
  );
  int i = 9;
  double rating = 2.0;
  final List<Marker> _markers = [];
  final List<Polyline> _polyLine = [];
  TextEditingController _textfildcontroller = TextEditingController();
//   New York City, NY

// Latitude: 40.7128
// Longitude: -74.0060
// Los Angeles, CA

// Latitude: 34.0522
// Longitude: -118.2437
// Chicago, IL

// Latitude: 41.8781
// Longitude: -87.6298

  @override
  void dispose() {
    _textfildcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCurrentLocationApp();
    super.initState();
    _markers.addAll([
      Marker(
          markerId: MarkerId("1"),
          position: LatLng(40.7209, -73.9969),
          onTap: () => {
                if (disenable)
                  {}
                else
                  {
                    _showDialog(
                        context,
                        " Green Village Used Clothing & Furniture",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7209, -73.9969)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("2"),
          position: LatLng(40.7181, -73.9963),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "Mother of Junk",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7181, -73.9963)} KM",
                        rating),
                  }
              }),
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        markerId: MarkerId("3"),
        position: LatLng(40.7131, -74.0100),
        onTap: () {
          // Handle marker tap if needed
          print('Marker tapped');
        },
      ),
      Marker(
          markerId: MarkerId("4"),
          position: LatLng(40.7085, -73.9579),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "Reuse America Vintage Warehouse",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7085, -73.9579)} KM",
                        rating),
                  }
              }),
      Marker(
        markerId: MarkerId("5"),
        position: LatLng(40.6772, -73.9108),
        onTap: () => _showDialog(
            context,
            "Brooklyn Vintiques",
            "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.6772, -73.9108)} KM",
            rating),
      ),
      Marker(
          markerId: MarkerId("6"),
          position: LatLng(40.7221, -73.9382),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "The Thing",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7221, -73.9382)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("7"),
          position: LatLng(40.7587, -73.9759),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "Eclectic Collectibles & Antiques",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7587, -73.9759)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("8"),
          position: LatLng(40.7261, -73.9902),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "Trailer Park",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7261, -73.9902)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("9"),
          position: LatLng(40.7306, -73.9866),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "The Junkluggers of Manhattan & Brooklyn",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7306, -73.9866)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("10"),
          position: LatLng(40.7318, -73.9955),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "Cobblestones",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7318, -73.9955)} KM",
                        rating),
                  }
              }),
      Marker(
          markerId: MarkerId("11"),
          position: LatLng(40.7200, -73.9980),
          onTap: () => {
                if (disenable)
                  {_onMapTapped(_currentLocation)}
                else
                  {
                    _showDialog(
                        context,
                        "New York Old Iron",
                        "${distance(_currentLocation!.latitude, _currentLocation!.longitude, 40.7200, -73.9980)} KM",
                        rating),
                  }
              }),
    ]);
  }

  void _showDialog(
      BuildContext context, String title, String dist, double rat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Flexible(
          child: AlertDialog(
            elevation: 10,
            backgroundColor: Colors.white,
            title: Flexible(
              child: Center(
                  child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "os-semibold",
                    fontSize: 19,
                    color: const Color.fromARGB(255, 34, 78, 136)),
              )),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Distance:",
                          style: TextStyle(
                              fontFamily: "os-semibold",
                              fontSize: 17,
                              color: Color(0xff333333)),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            dist,
                            style: TextStyle(
                                fontFamily: "os-bold",
                                fontSize: 17,
                                color: Color.fromARGB(255, 209, 34, 11)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "Rating:",
                          style: TextStyle(
                              fontFamily: "os-semibold",
                              fontSize: 17,
                              color: Color(0xff333333)),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        RatingStars(
                          value: rat,
                          starCount: 5,
                          starSize: 20,
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          valueLabelRadius: 10,
                          maxValue: 5,
                          starSpacing: 2,
                          maxValueVisibility: true,
                          valueLabelVisibility: false,
                          animationDuration: Duration(milliseconds: 1000),
                          valueLabelPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: Colors.yellow,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff5D8FD1)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                          side: BorderSide(
                            color: Color(0xffE8E8E8),
                          ))),
                      shadowColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 213, 211, 211))),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                        fontFamily: "os-bold",
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   actions: [
        //     IconButton(
        //         style: ButtonStyle(iconSize: WidgetStateProperty.all(30)),
        //         onPressed: () {
        //           showSearch(context: context, delegate: dataSearch());
        //         },
        //         icon: Icon(
        //           Icons.search,
        //           color: Colors.white,
        //         )),
        //   ],
        // ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 4),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GNav(
                gap: 4,
                padding: EdgeInsets.all(14),
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    fontFamily: "os-bold", fontSize: 15, color: Colors.white),
                color: Color(0xff333333),
                activeColor: Colors.white,
                tabActiveBorder:
                    Border.all(color: Color.fromARGB(255, 239, 238, 238)),
                tabBackgroundColor: Color(0xffC5D9F3),
                tabs: const [
                  GButton(
                    icon: Icons.home_filled,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.request_page_outlined,
                    text: "Request",
                  ),
                  GButton(
                    icon: Icons.person_2_outlined,
                    text: "Profile",
                  ),
                ]),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              circles: _currentLocation != null
                  ? {
                      Circle(
                        circleId: CircleId('currentLocationCircle'),
                        center: _currentLocation!,
                        radius: 100, // Radius in meters
                        strokeColor:
                            Colors.blue.withOpacity(0.5), // Circle fill color
                        fillColor: Colors.blue, // Circle stroke color
                        strokeWidth: 10, // Stroke width
                      ),
                    }
                  : {},
              onTap: _onMapTapped,
              markers: _markers.toSet(),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                // _controller.complete(controller);
                mapController = controller;

                controller.animateCamera(
                    CameraUpdate.newLatLng(LatLng(40.7128, -74.0060)));
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 70,
              child: TypeAheadField(
                  showOnFocus: true,
                  builder: (context, controller, focusNode) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          autofocus: false,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search Locations...',
                            prefixIcon: Icon(Icons.search,
                                color: Color.fromARGB(255, 177, 174, 174)),
                            hintStyle: TextStyle(
                                fontFamily: "os-reg",
                                fontSize: 14,
                                color: Color.fromARGB(255, 177, 174, 174)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, String suggestions) {
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        title: Text(
                          suggestions,
                          style: TextStyle(
                              fontFamily: "os-semibold",
                              fontSize: 15,
                              color: Color.fromARGB(255, 177, 174, 174)),
                        ),
                      ),
                    );
                  },
                  onSelected: (value) {
                    setState(() {
                      String select = _textfildcontroller.text = value;
                      LatLng? l = SearchService.location[select];
                      mapController.animateCamera(CameraUpdate.newLatLng(l!));
                    });
                  },
                  suggestionsCallback: (String search) {
                    return SearchService.getSuggestions(search);
                  }),
            ),
            Positioned(
                top: 50,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: Color(0xffF1F1F1),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Color(0xffCCCCCC))),
                  child: Icon(
                    Icons.person,
                    color: Color(0xffCCCCCC),
                    size: 40,
                  ),
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              right: 5,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _getCurrentLocation();
                  // Handle GPS button press
                },
                child: Icon(
                  Icons.my_location,
                  color: Color(0xff2963AF),
                  size: 40,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 5,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Color(0xffE8E8E8),
                        ))),
                    shadowColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 213, 211, 211))),
                onPressed: () {
                  _goToTargetLocation(2);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Color(0xff333333),
                      size: 24,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontFamily: "os-bold", color: Color(0xff333333)),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.30,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Color(0xffE8E8E8),
                        ))),
                    shadowColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 213, 211, 211))),
                onPressed: () {
                  _goToTargetLocation(0);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.store_rounded,
                      color: Color(0xff333333),
                      size: 24,
                    ),
                    Text(
                      "Store",
                      style: TextStyle(
                          fontFamily: "os-bold", color: Color(0xff333333)),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.58,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Color(0xffE8E8E8),
                        ))),
                    shadowColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 213, 211, 211))),
                onPressed: () {
                  _goToTargetLocation(1);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.store_rounded,
                      color: Color(0xff333333),
                      size: 24,
                    ),
                    Text(
                      "Store",
                      style: TextStyle(
                          fontFamily: "os-bold", color: Color(0xff333333)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _getCurrentLocation() async {
    // Request permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        disenable = false;
      });
      // Move camera to the current location
      mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    } else {
      // Handle permission denied case
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Location permission denied')));
    }
  }

  void _goToTargetLocation(int p) {
    mapController.animateCamera(CameraUpdate.newLatLng(_markers[p].position));
    // Simulate a marker tap by calling the method directly
    _markers[p].onTap!();
  }
}
