import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/helpers/debouncer.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  final String _langage = 'es-Es';
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '623ed974a1ed6a11548cc97df2fd942f';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider(){
    
    getOnDisplatMovies();
    getPopularMovies();

  }

  Future<String> _getJsonData ( String endopoint, [int page = 1]) async {
    final url = Uri.https( _baseUrl , endopoint, {
      'api_key': _apiKey,
      'language': _langage,
      'page': '$page'
    } );

    final resp = await http.get(url);
    return resp.body;
  }

  getOnDisplatMovies () async {

    final data = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(data);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies () async {

    _popularPage++;

    final data = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(data);

    onPopularMovies = [ ...onPopularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{

    if( moviesCast.containsKey(movieId)) return moviesCast[movieId]!;    

    final data = await _getJsonData('3/movie/${movieId}/credits');
    final creditsResponse = CreditsResponse.fromJson( data );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie( String query ) async {
    
    final url = Uri.https( _baseUrl , '3/search/movie', {
      'api_key': _apiKey,
      'language': _langage,
      'query': query
    });

    final resp = await http.get(url);
    final searchResponse = SearchResponse.fromJson( resp.body );

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ){

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await searchMovie( value );
      _suggestionStreamController.add( results );
    } ;

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then( (_) => timer.cancel());
  }


}