import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:pure_match_technical_test/models/movie.dart';
import 'package:pure_match_technical_test/providers/movies_provider.dart'; 

class MovieSearchDelegate extends SearchDelegate {
 
  @override
  String get searchFieldLabel => 'Select an Admin';


  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(  
      textTheme: const TextTheme(  
        headline6: TextStyle(fontSize: 18.0, color: Color(0xFFC7C7C7)),
      ),
      appBarTheme: const AppBarTheme( 
        backgroundColor: Color(0xFF0F0F0F), 
      ),
      inputDecorationTheme: const InputDecorationTheme( 
        hintStyle: TextStyle(
          height: 1,
          color: Color(0xFFC7C7C7),
          fontSize: 18
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ), 
      ),
    );
  }
  
 
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Column(
        children: [ 
          Transform.rotate(
            angle: math.pi / 4,
            child:  IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFFC7C7C7)),
              onPressed: () => query = '', 
            ), 
          ), 
        ],
      ),
    ];
  }
  
 
  @override
  Widget? buildLeading(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            close(context, null); 
          },
        ), 
      ],
    );
  }

  
  @override
  Widget buildResults(BuildContext context) { 
    if((query.trim()).isEmpty){ 
      return _emptyContainer();
    } 
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
 
    moviesProvider.getSuggestionsByQuery(query); 
    return StreamBuilder( 
      stream: moviesProvider.suggestionStream, 
      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot){  
        if(!snapshot.hasData) return _emptyContainer();  
        final movies = snapshot.data; 
        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: ( _, int index) => _MovieItem(movie: movies[index])
        ); 
      },
    );
  }

   
  @override
  Widget buildSuggestions(BuildContext context) { 
    if((query.trim()).isEmpty){ 
      return _emptyContainer();
    } 
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false); 
    moviesProvider.getSuggestionsByQuery(query);
 
    return StreamBuilder( 
      stream: moviesProvider.suggestionStream, 
      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot){  
        if(!snapshot.hasData) return _emptyContainer();  
        final movies = snapshot.data; 
        return ListView.builder(
          itemCount: movies!.length,
          itemExtent: 90,
          itemBuilder: ( _, int index) => _MovieItem(movie: movies[index])
        );

      },
    );
  }

 
  Widget _emptyContainer() {
    return Container(
      color: const Color(0xFF2A2A2C),
      child: const Center(
        child: Icon(Icons.handshake, color: Color(0xFFFFFFFF), size: 130),
      ),
    );
  }

}
 
class _MovieItem extends StatelessWidget {

  final Movie movie; 
   
  const _MovieItem({
    Key? key, 
    required this.movie
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) { 
    movie.heroId = 'search-${movie.id}';
    return Container(
      color: const Color(0xFF0F0F0F), 
      child: ListTile( 
        contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        textColor: Colors.white,
        leading: Transform.scale(
          scale: 1.25,
          child: Container(
            width: 90,
            height: 90, 
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              border: Border.all(
                width: 2,
                color: Colors.green,
              ),
              image: DecorationImage(
                image: NetworkImage(movie.fullPostering), 
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  const AssetImage('assets/no-image.jpg');
                },
              ),
            ),
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () => debugPrint('jean movie.title: ${movie.title}'),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz_outlined, size: 40), 
          color: Colors.white, 
          onPressed: () => debugPrint('jean movie.originalTitle: ${movie.originalTitle}'),
        ),
      ),
    );
  }
}