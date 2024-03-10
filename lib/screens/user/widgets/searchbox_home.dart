import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';

class SearchBoxHome extends StatefulWidget {
  final void Function(String query, {required bool isLocation}) onChanged;

  const SearchBoxHome({
    super.key,
    required this.onChanged,
  });

  @override
  State<SearchBoxHome> createState() => _SearchBoxHomeState();
}

class _SearchBoxHomeState extends State<SearchBoxHome> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: indigoClr.withOpacity(0.4),
        borderRadius: br6,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Looking for something!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: indigoClr,
              ),
            ),
            h10,
            TextField(
              controller: _searchController,
              onChanged: (value) => widget.onChanged(value, isLocation: false),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                filled: true,
                border: InputBorder.none,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: indigoClr, width: 2),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: indigoClr,
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      widget.onChanged('', isLocation: false);
                    },
                    icon: const Icon(Icons.clear)),
                hintText: 'Search',
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: indigoClr),
              ),
            ),
            h10,
            TextField(
              controller: _locationController,
              onChanged: (value) => widget.onChanged(value, isLocation: true),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                filled: true,
                border: InputBorder.none,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: indigoClr, width: 2),
                ),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: indigoClr,
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      _locationController.clear();
                      widget.onChanged('', isLocation: true);
                    },
                    icon: const Icon(Icons.clear)),
                hintText: 'Location',
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: indigoClr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
