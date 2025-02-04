import 'package:flutter/material.dart';

class SearchService {
  static final List<String> location = [
    "new york",
    "los angeles",
    "new delhi",
    "san antonio",
    "san diego"
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(location);
    matches.retainWhere(
        (element) => element.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
