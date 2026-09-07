import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LocationSearchField extends StatelessWidget {
  final Function(double lat, double lng, String address) onLocationSelected;

  const LocationSearchField({super.key, required this.onLocationSelected});
  Future<List<Map<String, String>>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    return (data["predictions"] as List)
        .map(
          (s) => {
            "description": s["description"] as String,
            "place_id": s["place_id"] as String,
          },
        )
        .toList();
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final loc = data["result"]["geometry"]["location"];

    return {
      "lat": loc["lat"],
      "lng": loc["lng"],
      "address": data["result"]["formatted_address"],
    };
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Map<String, String>>(
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: "Search for your location",
            border: OutlineInputBorder(),
          ),
        );
      },

      suggestionsCallback: (pattern) async {
        return await fetchSuggestions(pattern);
      },

      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion["description"]!));
      },

      onSelected: (suggestion) async {
        final details = await fetchPlaceDetails(suggestion["place_id"]!);

        onLocationSelected(details["lat"], details["lng"], details["address"]);
      },
    );
  }
}
