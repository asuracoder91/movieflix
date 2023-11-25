import 'package:flutter/material.dart';

import '../../../core/api/api_service.dart';
import '../../../model/movie_detail_model.dart';
import '../../components/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final String title, poster, id, tag;

  const DetailScreen({
    super.key,
    required this.title,
    required this.poster,
    required this.id,
    required this.tag,
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
          centerTitle: false,
          title: const Text(
            'Back to list',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Hero(
          tag: widget.tag,
          child: Stack(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.poster}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
                colorBlendMode: BlendMode.darken,
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
                        child: Text(widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      const SizedBox(height: 15),
                      FutureBuilder(
                          future: detailMovie,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StarRating(rating: snapshot.data!.vote),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      for (int i = 0;
                                          i < snapshot.data!.genres.length;
                                          i++)
                                        Text(
                                          '${snapshot.data!.genres[i]['name']}${i == snapshot.data!.genres.length - 1 ? '' : ', '}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
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
                                    width:
                                        MediaQuery.of(context).size.width - 40,
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
          ),
        ));
  }
}
