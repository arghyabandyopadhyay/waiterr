import 'package:flutter/material.dart';

import '../theme.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String searchText) searchOperation;
  const SearchTextField(
      {Key? key, required this.searchController, required this.searchOperation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: searchController,
      style: GlobalTextStyles.searchTextStyle,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black87,
          ),
          focusColor: GlobalTheme.primaryGradient2[2],
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: "Search...",
          hintStyle: GlobalTextStyles.searchTextStyle),
      onChanged: searchOperation,
    );
  }
}
