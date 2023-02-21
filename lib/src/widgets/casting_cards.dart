import 'package:flutter/cupertino.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {

  final int id;

  const CastingCards({
    Key? key,
    required this.id
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast( id ),
      builder: ( __, AsyncSnapshot<List<Cast>> snapshot){

        if(!snapshot.hasData){
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }

        final cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 300),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: ( _ , int index) =>_CastCard(cast: cast[index],)
          ),
        );
      }
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;

  const _CastCard({Key? key, required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/img/loading.gif'),
              image: NetworkImage(cast.FullProfileImg),
              height: 140,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}