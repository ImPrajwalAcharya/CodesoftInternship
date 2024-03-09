import 'dart:convert';

import 'package:http/http.dart' as http;

fetchRandomQuote() async {
  final response = await http.get(Uri.parse('https://api.quotable.io/random'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load quote');
  }
}
