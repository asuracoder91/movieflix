import 'dart:math';

import 'package:deviflix/features/home/screens/poster_screen.dart';
import 'package:flutter/material.dart';

import '../../../model/movie_model.dart';

ListView getNowOnCinema(
    AsyncSnapshot<List<MovieModel>> snapshot, double width, double height) {
  // 필름 홀 사이의 간격과 크기
  const double holeSize = 10.0;
  const double holeSpacing = 15.0;
  const double filmHeight = 20.0; // 필름 홀의 높이
  const double borderRadius = 2.0; // 필름 홀의 모서리

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      final movie = snapshot.data![index];
      final heroTag = 'movie-${movie.id}-${Random().nextInt(1000000)}';

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PosterScreen(
                      title: movie.title,
                      poster: movie.poster,
                      id: movie.id,
                      tag: heroTag),
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
              transitionDuration: const Duration(milliseconds: 150), // 전환 시간 설정
              reverseTransitionDuration: const Duration(milliseconds: 100),
            ),
          );
        },
        child: Container(
          color: const Color(0xFF676767),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 위쪽 필름 홀
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: filmHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      (width / holeSpacing).round(), // 필름 홀의 개수를 계산
                      (index) => Container(
                        width: holeSize,
                        height: holeSize,
                        margin: const EdgeInsets.symmetric(
                            vertical: filmHeight / 2 - holeSize / 2),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.circular(borderRadius)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 아래쪽 필름 홀
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: filmHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      (width / holeSpacing).round(),
                      (index) => Container(
                        width: holeSize,
                        height: holeSize,
                        margin: const EdgeInsets.symmetric(
                            vertical: filmHeight / 2 - holeSize / 2),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.circular(borderRadius)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 영화 포스터
              Hero(
                tag: heroTag,
                child: Container(
                  width: width,
                  height: height,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
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
              ),
            ],
          ),
        ),
      );
    },
  );
}
