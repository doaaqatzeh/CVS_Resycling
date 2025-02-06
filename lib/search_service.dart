import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchService {
  static final Map<String, LatLng> location = {
    "New York City": LatLng(40.7128, -74.0060),
    "Los Angeles": LatLng(34.0522, -118.2437),
    "Chicago": LatLng(41.8781, -87.6298)
  };

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(location.keys);
    matches.retainWhere(
        (element) => element.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
