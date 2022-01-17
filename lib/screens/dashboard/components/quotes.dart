import 'dart:convert';
import 'dart:io';

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

  Future<Quote> fetchAlbumPaperQuotes() async {
    //http.Request request= http.Request("GET", Uri.parse("https://api.paperquotes.com/apiv1/quotes/?lang=de"));
    //request.headers.addEnies('Authorization', 'Token f4d8d9ef90402395cdb6f53047cba65dc17b9316');

    final response = await http.get(
      Uri.parse('https://api.paperquotes.com/apiv1/quotes/?lang=en'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            'Token f4d8d9ef90402395cdb6f53047cba65dc17b9316',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final json = jsonDecode(response.body);
      final jsonresult = json['results'];
      print(json['results']);
      print(jsonresult[0]['quote']);
      return Quote.fromJson(json['results'][0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Quote> fetchAlbum() async {
    final response = await http.get(
      Uri.parse('https://type.fit/api/quotes'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final json = jsonDecode(response.body);
      //  final jsonresult = json[0]['text'];
      return Quote.fromJson(json[0]);
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
