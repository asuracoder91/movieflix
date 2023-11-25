import 'dart:math';

import 'package:flutter/material.dart';

import '../../../model/movie_model.dart';
import '../screens/detail_screen.dart';

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
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                  title: movie.title,
                  poster: movie.poster,
                  id: movie.id,
                  tag: heroTag),
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