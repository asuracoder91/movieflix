import 'dart:math';

import 'package:flutter/material.dart';

import '../../../model/movie_model.dart';
import '../screens/poster_screen.dart';

ListView getComingSoon(
    AsyncSnapshot<List<MovieModel>> snapshot, double width, double height) {
  return ListView.separated(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${movie.poster}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: width,
              child: Text(
                movie.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 4,
    ),
  );
}
