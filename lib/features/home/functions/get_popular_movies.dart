import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../model/movie_model.dart';
import '../screens/detail_screen.dart';

class PopularMoviesView extends StatefulWidget {
  final AsyncSnapshot<List<MovieModel>> snapshot;

  const PopularMoviesView({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<PopularMoviesView> createState() => _PopularMoviesViewState();
}

class _PopularMoviesViewState extends State<PopularMoviesView> {
  late PageController pageController;
  late List<MovieModel> copyData;
  int currentPage = 1;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    if (widget.snapshot.data!.isEmpty) return;
    copyData = [
      widget.snapshot.data!.last,
      ...widget.snapshot.data!,
      widget.snapshot.data!.first,
    ];
    pageController =
        PageController(viewportFraction: 0.87, initialPage: currentPage);
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
          pageOffset = pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //무한 스크롤 구현 못함.. 일단 보류
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: copyData.length,
          itemBuilder: (context, index) {
            final movie = copyData[index];
            final heroTag = 'movie-${movie.id}-${Random().nextInt(1000000)}';
            final backgroundImage = index.isEven
                ? 'assets/images/green.png'
                : 'assets/images/purple.png';

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
              child: AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;

                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 192,
                      width: Curves.easeOut.transform(value) * 330,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 330, // 배경 이미지의 너비를 330으로
                      height: 192, // 배경 이미지의 높이를 192로
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 330 / 2 - (113 / 2), // 포스터를 가로 중앙에 위치시키기 위한 식
                      top: 192 / 2 - (170 / 2), // 포스터를 세로 중앙에 위치시키기 위한 식
                      child: Hero(
                        tag: heroTag,
                        child: Container(
                          width: 113, // 포스터의 너비를 113으로
                          height: 170, // 포스터의 높이를 170으로
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 5,
                                blurRadius: 16,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.poster}',
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
        ),
        Positioned(
          left: 50, // 기본 위치 설정
          top: 270,
          child: AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double offset = 0.0;
              if (pageController.position.haveDimensions) {
                offset = (pageController.page! - currentPage) * -680.0;
              }

              return Transform.translate(
                // 이동 효과를 적용합니다.
                offset: Offset(offset, 0.0),
                child: child,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 88,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Animation",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
                const Gap(7),
                SizedBox(
                  width: 300,
                  child: Text(
                    copyData.isEmpty
                        ? widget.snapshot.data![0].title
                        : copyData[currentPage % copyData.length].title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
