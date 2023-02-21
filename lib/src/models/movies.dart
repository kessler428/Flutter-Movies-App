import 'dart:convert';

class Movie {
  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  String? heroId;

  get FullPosterImg {

    if(posterPath != null){
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }

    return 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png';
  }

  get FullBackdropPath {

    if(posterPath != null){
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }

    return 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png';
  }

  factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
    adult         : json["adult"],
    backdropPath  : json["backdrop_path"],
    genreIds      : List<int>.from(json["genre_ids"].map((x) => x)),
    id            : json["id"],
    originalTitle : json["original_title"],
    overview      : json["overview"],
    popularity    : json["popularity"].toDouble(),
    posterPath    : json["poster_path"],
    releaseDate   : json["release_date"],
    title         : json["title"],
    video         : json["video"],
    voteAverage   : json["vote_average"].toDouble(),
    voteCount     : json["vote_count"],
  );
}