import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// main function, main Class declaring
void main() {
  runApp(const Movieflix());
}

class Movieflix extends StatelessWidget {
  const Movieflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movieflix',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// Movie Model
class MovieModel {
  final String poster, title, id;

  MovieModel.fromJson(Map<String, dynamic> json)
      : poster = json['poster_path'],
        title = json['original_title'],
        id = json['id'].toString();
}

// Movie Detail Model
class MovieDetailModel {
  final String poster, title, id, overview;
  final List<dynamic> genres;
  final double vote;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : poster = json['poster_path'],
        title = json['original_title'],
        vote = json['vote_average'].toDouble(),
        overview = json['overview'],
        genres = json['genres'],
        id = json['id'].toString();
}

// Http connect Api Service Class
class ApiService {
  static String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static String popular = "popular";
  static String nowPlaying = "now-playing";
  static String upcoming = "coming-soon";
  static String movie = "movie";

  static Future<List<MovieModel>> getMovies(String order) async {
    List<MovieModel> movieInstances = [];
    // order = popular, nowPlaying, upcoming
    if (order == "popular") {
      order = popular;
    } else if (order == "nowPlaying") {
      order = nowPlaying;
    } else if (order == "upcoming") {
      order = upcoming;
    }
    final url = Uri.parse('$baseUrl/$order');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movies = jsonDecode(utf8.decode(response.bodyBytes));
      for (var movie in movies['results']) {
        final mov = MovieModel.fromJson(movie);
        movieInstances.add(mov);
      }

      return movieInstances;
    }
    throw Error();
  }

  static Future<MovieDetailModel> getMovieByID(String id) async {
    final url = Uri.parse('$baseUrl/$movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movie = jsonDecode(utf8.decode(response.bodyBytes));
      final mov = MovieDetailModel.fromJson(movie);
      return mov;
    }
    throw Error();
  }
}

// Drawing HomeScreen
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<MovieModel>> popularMovies =
      ApiService.getMovies("popular");
  final Future<List<MovieModel>> nowPlaying =
      ApiService.getMovies("nowPlaying");
  final Future<List<MovieModel>> upcoming = ApiService.getMovies("upcoming");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text('Popular Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 210,
                child: FutureBuilder(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return makeList(snapshot, 240, 160);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const Text('Now in Cinemas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 170,
                child: FutureBuilder(
                  future: nowPlaying,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return makeList(snapshot, 120, 120);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const Text('Coming Soon',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 170,
                child: FutureBuilder(
                  future: upcoming,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return makeList(snapshot, 120, 120);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView makeList(
      AsyncSnapshot<List<MovieModel>> snapshot, double width, double height) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final movie = snapshot.data![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                    title: movie.title, poster: movie.poster, id: movie.id),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${movie.poster}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: width,
                child: Text(
                  movie.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 10,
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String title, poster, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.poster,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetailModel> detailMovie;

  @override
  void initState() {
    super.initState();
    detailMovie = ApiService.getMovieByID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Back to list',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${widget.poster}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
            ),
            Positioned(
              top: 300,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Text(widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder(
                        future: detailMovie,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StarRating(rating: snapshot.data!.vote),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data!.genres.length;
                                        i++)
                                      Text(
                                        '${snapshot.data!.genres[i]['name']}${i == snapshot.data!.genres.length - 1 ? '' : ', '}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'Storyline',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Text(
                                    snapshot.data!.overview,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Text("...");
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int filledStars = (rating / 2).round();
    int grayStars = 5 - filledStars;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          if (index < filledStars) {
            return const Icon(Icons.star, color: Colors.yellow, size: 24);
          } else {
            return const Icon(Icons.star, color: Colors.grey, size: 24);
          }
        },
      ),
    );
  }
}
