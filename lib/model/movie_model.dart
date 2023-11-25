class MovieModel {
  final String poster, title, id;

  MovieModel.fromJson(Map<String, dynamic> json)
      : poster = json['poster_path'],
        title = json['original_title'],
        id = json['id'].toString();
}
