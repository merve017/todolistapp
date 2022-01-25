import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Quotes extends StatelessWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: fetchAlbum(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('"${snapshot.data!.quote}" - ${snapshot.data!.author}',
              style: const TextStyle(fontStyle: FontStyle.italic));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Text("default");
        }
      },
    );
  }

  Future<Quote> fetchAlbum() async {
    final response = await http.get(
      Uri.parse('https://type.fit/api/quotes'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final json = jsonDecode(response.body);
      final Random random = Random();
      //  final jsonresult = json[0]['text'];
      return Quote.fromJson(json[random.nextInt(250)]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Quote {
  final String quote;
  final String author;

  Quote({
    required this.quote,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['text'],
      author: json['author'],
    );
  }
}
