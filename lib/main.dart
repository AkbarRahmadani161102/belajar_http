// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as htt;

Future<List<Cat>> fetchRandomCat() async {
  final response = await http.get(
    Uri.parse('https://api.thecatapi.com/v1/images/search'),
  );

  if (response.statusCode == 200) {
    return List<Cat>.from(
      json.decode(response.body).map((cat) => Cat.fromJson(cat)),
    );
  } else {
    throw Exception('Failed to load cat');
  }
}

class Cat {
  final String id;
  final String url;
  final int width;
  final int height;

  Cat({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['heigt'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Cat>> futureRandomCat;
  @override
  void initState() {
    super.initState();
    futureRandomCat = fetchRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Cat>>(
            future: futureRandomCat,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.main,
                    children: <Widget>[
                      Image.network(snapshot.data![0].url),
                      ListTile(
                        leading: const Icon(icon.pets),
                        title: Text(snapshot.data![0].id),
                        subtitle: Tex(
                          'width: ${snapshot.data![0].width} Height: ${snapshot.data![0].height}'
                        ),
                      ),
                    ],
                  ),
                )
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
