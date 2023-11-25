import 'package:deviflix/core/core.dart';
import 'package:deviflix/features/home/functions/get_coming_soon.dart';
import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../../../model/movie_model.dart';
import '../functions/get_popular_movies.dart';

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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          leading: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: DFIcons.bars,
              onPressed: () {},
            ),
          ),
          title: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/deviflix.png',
              width: 118,
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: DFIcons.search,
                onPressed: () {},
              ),
            ),
          ],
          flexibleSpace: Column(
            children: [
              Container(
                height: kToolbarHeight,
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // AppBar 상단의 색상을 설정합니다.
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.0, 0.6),
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.topCenter,
              height: 371,
              child: FutureBuilder(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PopularMoviesView(snapshot: snapshot);
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
                    return getComingSoon(snapshot, 120, 120);
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
                    return getComingSoon(snapshot, 120, 120);
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
    );
  }
}
