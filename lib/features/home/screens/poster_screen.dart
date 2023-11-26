import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/api/api_service.dart';
import '../../../core/core.dart';
import '../../../model/movie_detail_model.dart';
import '../../components/star_rating.dart';

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
                      child: Text(widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                    FutureBuilder(
                        future: detailMovie,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data!.genres.length;
                                        i++)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: DFColors.labelColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${snapshot.data!.genres[i]['name']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                StarRating(rating: snapshot.data!.vote),
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
            ],
          ),
        ));
  }
}
