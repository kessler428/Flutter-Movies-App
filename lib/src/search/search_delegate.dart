

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar Peliculas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon( Icons.clear )
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () =>  close(context, null),
      icon: const Icon(Icons.arrow_back)
    );
    
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('hola');
    
  }

  Widget _EmptyContainer(){
    return const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100,)
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if( query.isEmpty ){
      _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery( query );
    
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( __, AsyncSnapshot<List<Movie>> snapshot) {

        if( !snapshot.hasData) return _EmptyContainer();

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies?.length,
          itemBuilder: ( _, int index) => _MovieItems(movies![index])
        );

      }
    );

  }

}

class _MovieItems extends StatelessWidget {

  final Movie movie;

  const _MovieItems( this.movie );

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          image: NetworkImage( movie.FullBackdropPath ),
          placeholder: const AssetImage('assets/img/no-image.jpg'),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text( movie.originalTitle ),
      onTap: (){
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}