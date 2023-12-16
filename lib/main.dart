import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Album>> fetchAlbumList() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    final albums = jsonDecode(response.body);
    return (albums as List<dynamic>)
        .map((dynamic album) => Album.fromJson(album as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to Load List Album');
  }
}

Future<ChukNorris> fetchChuckNorris() async {
  final response = await http.get(
    Uri.parse('https://api.chucknorris.io/jokes/random'),
  );

  if (response.statusCode == 200) {
    return ChukNorris.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load chuck norris.');
  }
}

class ChukNorris {
  final String id;
  final String value;
  final String iconUrl;

  ChukNorris({
    required this.id,
    required this.value,
    required this.iconUrl,
  });

  factory ChukNorris.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'value': String value,
        'icon_url': String iconUrl,
      } =>
        ChukNorris(
          id: id,
          value: value,
          iconUrl: iconUrl,
        ),
      _ => throw const FormatException('Failed to load chu.'),
    };
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Future<Album> futureAlbum;
  // late Future<ChukNorris> futureChuckNorris;
  late Future<List<Album>> futureAlbumList;

  @override
  void initState() {
    super.initState();
    // futureAlbum = fetchAlbum();
    // futureChuckNorris = fetchChuckNorris();
    futureAlbumList = fetchAlbumList();
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
          child: FutureBuilder<List<Album>>(
            future: futureAlbumList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(snapshot.data![index].id.toString()),
                        title: Text(snapshot.data![index].title),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
