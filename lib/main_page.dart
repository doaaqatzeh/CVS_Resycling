import 'dart:async';

import 'package:cvsr/dataSearch.dart';
import 'package:cvsr/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.7128, -74.0060),
    zoom: 14.0,
  );
  int i = 9;
  double rating = 2.0;
  final List<Marker> _markers = [];
  TextEditingController _textfildcontroller = TextEditingController();
  @override
  void dispose() {
    _textfildcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _markers.addAll([
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(40.7129, -74.0061),
        onTap: () => _showDialog(context, "store name", "${i} KM", rating),
      ),
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        markerId: MarkerId("2"),
        position: LatLng(40.7200, -74.0090),
        onTap: () => _showDialog(context, "store name", "${i} KM", rating),
      ),
      Marker(
        markerId: MarkerId("3"),
        position: LatLng(40.7131, -74.0100),
        onTap: () => _showDialog(context, "store name", "${i} KM", rating),
      ),
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        markerId: MarkerId("4"),
        position: LatLng(40.7170, -74.0070),
        onTap: () => _showDialog(context, "store name", "${i} KM", rating),
      ),
    ]);
  }

  void _showDialog(
      BuildContext context, String title, String dist, double rat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffECF0F6),
          title: Center(
              child: Text(
            title,
            style: TextStyle(
                fontFamily: "os-bold", fontSize: 19, color: Color(0xff002F6C)),
          )),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.65,
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
                      Text(
                        dist,
                        style: TextStyle(
                            fontFamily: "os-bold",
                            fontSize: 17,
                            color: Color(0xff007A3D)),
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
                        width: 80,
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
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
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
                      fontFamily: "os-semibold",
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ],
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GNav(
                gap: 4,
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontFamily: "os-bold", fontSize: 14),
                color: Color(0xffCCCCCC),
                activeColor: Color(0xff333333),
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
              markers: Set<Marker>.of(_markers),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
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
                      );
                    },
                    itemBuilder: (context, String suggestions) {
                      return ListTile(
                        title: Text(suggestions),
                      );
                    },
                    onSelected: (value) {
                      setState(() {
                        _textfildcontroller.text = value;
                      });
                    },
                    suggestionsCallback: (String search) {
                      return SearchService.getSuggestions(search);
                    })),
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
              bottom: 110,
              right: 5,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
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
              left: 10,
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
                onPressed: () {},
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
              left: 125,
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
                onPressed: () {},
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
              left: 240,
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
                onPressed: () {},
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
        )

        // Center(
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Container(
        //             width: 270,
        //             height: 50,
        //             decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(30),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Color(0xffF1F1F1),
        //                     offset: Offset(0, 2),
        //                     blurRadius: 4,
        //                   )
        //                 ]),
        //             child: TextField(
        //               decoration: InputDecoration(
        //                   labelText: "search....",
        //                   labelStyle: TextStyle(
        //                       color: Color(0xff002F6C),
        //                       fontFamily: "os-bold",
        //                       fontSize: 13),
        //                   border: OutlineInputBorder(
        //                       borderSide: BorderSide(color: Colors.white),
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(30))),
        //                   prefixIcon: IconButton(
        //                       onPressed: () {
        //                         showSearch(
        //                             context: context, delegate: dataSearch());
        //                       },
        //                       icon: Icon(
        //                         Icons.search_rounded,
        //                         color: Color(0xff002F6C),
        //                       ))),
        //             ),
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Container(
        //             padding: EdgeInsets.all(9),
        //             decoration: BoxDecoration(
        //                 color: Color(0xffF1F1F1),
        //                 borderRadius: BorderRadius.all(Radius.circular(50)),
        //                 border: Border.all(color: Color(0xffCCCCCC))),
        //             child: Icon(
        //               Icons.person,
        //               color: Color(0xffCCCCCC),
        //               size: 40,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 430, right: 16),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             FloatingActionButton(
        //               backgroundColor: Colors.white,
        //               onPressed: () {},
        //               child: Icon(
        //                 Icons.gps_fixed,
        //                 size: 30,
        //                 color: Color(0xff2963AF),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       SingleChildScrollView(
        //         child: Center(
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               ElevatedButton(
        //                 style: ButtonStyle(
        //                     backgroundColor:
        //                         MaterialStateProperty.all(Colors.white),
        //                     padding:
        //                         MaterialStateProperty.all(EdgeInsets.all(14)),
        //                     shape: MaterialStateProperty.all(
        //                         RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(16),
        //                             side: BorderSide(
        //                               color: Color(0xffE8E8E8),
        //                             ))),
        //                     shadowColor: WidgetStateProperty.all(
        //                         Color.fromARGB(255, 213, 211, 211))),
        //                 onPressed: () {},
        //                 child: Row(
        //                   children: [
        //                     Icon(
        //                       Icons.home_filled,
        //                       color: Color(0xff333333),
        //                       size: 24,
        //                     ),
        //                     Text(
        //                       "Home",
        //                       style: TextStyle(
        //                           fontFamily: "os-bold",
        //                           color: Color(0xff333333)),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 15,
        //               ),
        //               ElevatedButton(
        //                 style: ButtonStyle(
        //                     backgroundColor:
        //                         MaterialStateProperty.all(Colors.white),
        //                     padding:
        //                         MaterialStateProperty.all(EdgeInsets.all(14)),
        //                     shape: MaterialStateProperty.all(
        //                         RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(16),
        //                             side: BorderSide(
        //                               color: Color(0xffE8E8E8),
        //                             ))),
        //                     shadowColor: WidgetStateProperty.all(
        //                         Color.fromARGB(255, 213, 211, 211))),
        //                 onPressed: () {},
        //                 child: Row(
        //                   children: [
        //                     Icon(
        //                       Icons.store_rounded,
        //                       color: Color(0xff333333),
        //                       size: 24,
        //                     ),
        //                     Text(
        //                       "Store1",
        //                       style: TextStyle(
        //                           fontFamily: "os-bold",
        //                           color: Color(0xff333333)),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 15,
        //               ),
        //               ElevatedButton(
        //                 style: ButtonStyle(
        //                     backgroundColor:
        //                         MaterialStateProperty.all(Colors.white),
        //                     padding:
        //                         MaterialStateProperty.all(EdgeInsets.all(14)),
        //                     shape: MaterialStateProperty.all(
        //                         RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(16),
        //                             side: BorderSide(
        //                               color: Color(0xffE8E8E8),
        //                             ))),
        //                     shadowColor: WidgetStateProperty.all(
        //                         Color.fromARGB(255, 213, 211, 211))),
        //                 onPressed: () {},
        //                 child: Row(
        //                   children: [
        //                     Icon(
        //                       Icons.store_rounded,
        //                       color: Color(0xff333333),
        //                       size: 24,
        //                     ),
        //                     Text(
        //                       "Store1",
        //                       style: TextStyle(
        //                           fontFamily: "os-bold",
        //                           color: Color(0xff333333)),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
        // GoogleMap(
        //   mapType: MapType.hybrid,
        //   initialCameraPosition: _kGooglePlex,
        //   onMapCreated: (GoogleMapController controller) {
        //     _controller.complete(controller);
        //   },
        // ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
        );
  }
}
