class MovieDetailModel {
  final String poster, title, id, overview;
  final List<dynamic> genres;
  final double vote;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : poster = json['poster_path'],
        title = json['original_title'],
        vote = json['vote_average'].toDouble(),
        overview = json['overview'],
        genres = json['genres'],
        id = json['id'].toString();
}
