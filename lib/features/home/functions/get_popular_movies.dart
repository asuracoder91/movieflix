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
  late PageController pageController = PageController(viewportFraction: 0.87);
  late List<MovieModel> extendedItems; // 페이지뷰에 사용될 아이템 리스트
  int currentPage = 0;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    extendedItems = [
      widget.snapshot.data!.last, // 리스트 시작 부분에 마지막 아이템을 추가
      ...widget.snapshot.data!, // 원본 데이터
      widget.snapshot.data!.first, // 리스트 끝 부분에 첫 번째 아이템을 추가
    ];
    pageController = PageController(
      viewportFraction: 0.87,
      initialPage: 1, // 실제 첫 번째 아이템이 표시되게 초기 페이지를 1로 설정합니다.
    );

    pageController.addListener(() {
      int next = pageController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
          pageOffset = pageController.page!;
        });
        // 시작 또는 끝에 도달하면 순환 효과를 위해 페이지를 조정합니다.
        if (currentPage == 0) {
          pageController.jumpToPage(extendedItems.length - 2);
        } else if (currentPage == extendedItems.length - 1) {
          pageController.jumpToPage(1);
        }
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: extendedItems.length,
          itemBuilder: (context, index) {
            final movie = extendedItems[index];
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
                    extendedItems.length < 22
                        ? widget
                            .snapshot
                            .data![currentPage % widget.snapshot.data!.length]
                            .title
                        : extendedItems[currentPage % extendedItems.length]
                            .title,
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
