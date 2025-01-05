import 'package:asmaa_mobile2/movie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 77, 77),
                  Color.fromARGB(255, 53, 7, 18)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie, size: 30, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Movies',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: MovieSection(),
        ),
      ),
    );
  }
}

class MovieSection extends StatefulWidget {
  const MovieSection({super.key});

  @override
  State<MovieSection> createState() => _MovieSection();
}

class _MovieSection extends State<MovieSection> {
  List movies = [];
  @override
  void initState() {
    super.initState();
    retrieveMovies();
  }

  void retrieveMovies() async {
    const url =
        '//http://jun.wuaze.com/api.php '; //http://jun.wuaze.com/api.php  //http://localhost/mobileAppApi/api.php
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        movies = data.map((obj) {
          String movieName = obj['name'].toString();
          String poster = obj['poster'].toString();
          String genre = obj['genre'].toString();
          String date = obj['release_date'].toString();

          return Movie(
              name: movieName, moviePoster: poster, genre: genre, date: date);
        }).toList();
      });
    }
  }

  void searchMovie(name) async {
    String url =
        '//http://jun.wuaze.com/searchMovie.php?name=$name'; //http://localhost/mobileAppApi/searchMovie.php?name=$name
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data.map((obj) {
          String movieName = obj['name'].toString();
          String poster = obj['poster'].toString();
          String genre = obj['genre'].toString();
          String date = obj['release_date'].toString();
          return Movie(
              name: movieName, moviePoster: poster, genre: genre, date: date);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            labelText: 'Type movie name or genre...',
            hintText: 'Action..',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          onChanged: (name) {
            searchMovie(name);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: Column(
                  children: [
                    Flexible(
                        child: Image.network(movies[index].moviePoster,
                            fit: BoxFit.cover, width: double.infinity)),
                    SizedBox(height: 5),
                    GridTileBar(
                      backgroundColor: Color.fromARGB(255, 204, 63, 63),
                      title: Text(movies[index].name),
                      subtitle: Text(movies[index].genre),
                      trailing: Text(movies[index].date),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
