import 'package:flutter/material.dart';

class dataSearch extends SearchDelegate<String> {
  final location = [
    "new york",
    "los angeles",
    "new delhi",
    "san antonio",
    "san diego"
  ];
  final recentLocation = [
    "new york",
    "los angeles",
  ];
  int pcolor = 0xff002F6C;
  int scolor = 0xffF7DC6F;
  int textcolor = 0xff333333;
  int bordercol = 0xffCCCCCC;
  int shadow = 0xffE8E8E8;
  int accentcolor = 0xffFFC107;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: TextStyle(
          color: Color(0xff333333),
          fontFamily: "os-semibold",
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentLocation
        : location.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.location_city),
        onTap: () {
          showResults(context);
        },
        title: RichText(
            text: TextSpan(
          text: suggestionList[index].substring(0, query.length),
          style: const TextStyle(
            color: Color(0xff333333),
            fontFamily: "os-semibold",
            fontSize: 12,
          ),
          children: [
            TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "os-semibold",
                  fontSize: 12,
                ))
          ],
        )),
      ),
      itemCount: suggestionList.length,
    );
  }
}
