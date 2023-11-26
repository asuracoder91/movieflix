import 'package:deviflix/core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/api/api_service.dart';
import '../../../model/movie_detail_model.dart';
import '../../components/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final String title, poster, id, tag;
  final List<dynamic> genres; // 장르 데이터를 추가합니다.
  final double rating; // 평점을 추가합니다.

  const DetailScreen({
    super.key,
    required this.title,
    required this.poster,
    required this.id,
    required this.tag,
    required this.genres, // 장르 인자를 추가합니다.
    required this.rating, // 평점 인자를 추가합니다.
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
        body: Stack(
          children: [
            Hero(
              tag: widget.tag,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.poster}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
                colorBlendMode: BlendMode.darken,
              ),
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
                      child: Hero(
                        tag: widget.title,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Hero(
                      tag: "star",
                      child: Material(
                        color: Colors.transparent,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: StarRating(rating: widget.rating)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 400,
                      child: Hero(
                        tag: "genres",
                        child: Material(
                          color: Colors.transparent,
                          child: Wrap(
                            spacing: 10, // 가로 간격
                            runSpacing: 10, // 세로 간격
                            children: [
                              for (int i = 0; i < widget.genres.length; i++)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: DFColors.chipColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${widget.genres[i]['name']}',
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
                    ),
                    const Gap(60),
                    FutureBuilder(
                        future: detailMovie,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
