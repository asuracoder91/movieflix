import 'package:deviflix/features/components/shimmer_arrows.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/api/api_service.dart';
import '../../../core/core.dart';
import '../../../model/movie_detail_model.dart';
import '../../components/star_rating.dart';
import 'detail_screen.dart';

class PosterScreen extends StatefulWidget {
  final String title, poster, id, tag;

  const PosterScreen({
    super.key,
    required this.title,
    required this.poster,
    required this.id,
    required this.tag,
  });

  @override
  State<PosterScreen> createState() => _PosterScreenState();
}

class _PosterScreenState extends State<PosterScreen> {
  late Future<MovieDetailModel> detailMovie;
  MovieDetailModel? movieDetails; // 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    detailMovie = ApiService.getMovieByID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // 사용자가 위로 스와이프할 때만 반응하도록 한다.
        if (details.primaryDelta != null && details.primaryDelta! < -20) {
          // 속도가 0보다 작으면 위로 스와이프하는 것이다.
          if (movieDetails != null) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DetailScreen(
                  title: widget.title,
                  poster: widget.poster,
                  id: widget.id,
                  tag: widget.tag,
                  genres: movieDetails!.genres, // 저장된 데이터를 전달합니다.
                  rating: movieDetails!.vote,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = 0.0;
                  var end = 1.0;
                  var curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration:
                    const Duration(milliseconds: 500), // 전환 시간 설정
                reverseTransitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leadingWidth: 100,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Gap(20),
                  DFIcons.back,
                  const Gap(6),
                  SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/deviflix.png',
                      width: 57,
                      alignment: Alignment.topLeft,
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(120),
                Hero(
                  tag: widget.tag,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.poster}',
                    width: 273,
                    height: 410,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Hero(
                          tag: widget.title,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: detailMovie,
                          builder: (context,
                              AsyncSnapshot<MovieDetailModel> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              movieDetails = snapshot.data; // 데이터를 변수에 저장합니다.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(20),
                                  Hero(
                                    tag: "genres",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Wrap(
                                        spacing: 10, // 가로 간격
                                        runSpacing: 10, // 세로 간격
                                        children: [
                                          for (int i = 0;
                                              i < snapshot.data!.genres.length;
                                              i++)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: DFColors.chipColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '${snapshot.data!.genres[i]['name']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: DFColors.darkTextColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(40),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Hero(
                                      tag: "star",
                                      child: Material(
                                        color: Colors.transparent,
                                        child: StarRating(
                                            rating: snapshot.data!.vote),
                                      ),
                                    ),
                                  ),
                                  const Gap(30),
                                  const ShimmerArrows(),
                                ],
                              );
                            }
                            return const Text("...");
                          }),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
