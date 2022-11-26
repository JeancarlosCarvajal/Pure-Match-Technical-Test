import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../helpers/debouncer.dart';

import '../models/movie.dart';

import '../models/seach_movie_response.dart'; 

class MoviesProvider extends ChangeNotifier { 

  final String? _apiKey = dotenv.env['TOKEN_API']; 
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500), 
  );
  final StreamController<List<Movie>> _suggestionStringController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStringController.stream;

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'languagepage': _language,
      // 'page': '$page',  // opcional
      'query': query

    });
    
    final responce = await http.get(url);
    final searchResponse = SearchResponse.fromJson(responce.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) {
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await searchMovie(value); 
      _suggestionStringController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), ( _ ) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(( _ ) => timer.cancel());
  }

}