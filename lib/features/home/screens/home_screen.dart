import 'package:deviflix/core/core.dart';
import 'package:deviflix/features/home/functions/get_coming_soon.dart';
import 'package:deviflix/features/home/functions/get_now_on_cinema.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
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
    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: Scaffold(
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
                  color: Theme.of(context).scaffoldBackgroundColor,
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
              Column(
                children: [
                  Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF262626),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D1D1D),
                    ),
                    height: 210,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/flame.png',
                                width: 16,
                              ),
                              const Gap(6),
                              GradientText(
                                'Now On Cinema',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                                colors: const [
                                  Color(0xFFBC0404),
                                  Color(0xFFFAFF00)
                                ],
                                gradientDirection: GradientDirection.btt,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 140,
                          child: FutureBuilder(
                            future: nowPlaying,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return getNowOnCinema(snapshot, 136, 96);
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
                  Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF262626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ddoza.png',
                      width: 22,
                    ),
                    const Gap(6),
                    const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 170,
                child: FutureBuilder(
                  future: upcoming,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return getComingSoon(snapshot, 86, 131);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
