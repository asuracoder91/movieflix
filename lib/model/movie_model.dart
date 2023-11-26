class MovieModel {
  final String poster, title, id;
  final List<dynamic> genres;

  MovieModel.fromJson(Map<String, dynamic> json)
      : poster = json['poster_path'],
        title = json['original_title'],
        genres = json['genre_ids'],
        id = json['id'].toString();
}
