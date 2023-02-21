import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppbar(
            title: movie.title,
            img: movie.FullBackdropPath
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterTitle(
                id: movie.heroId!,
                title: movie.title,
                originalTitle: movie.originalTitle,
                voteAvegare: movie.voteAverage,
                img: movie.FullPosterImg,
              ),
              _OverView(
                description: movie.overview,
              ),
              CastingCards( id: movie.id)
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppbar extends StatelessWidget {

  final String title;
  final String img;

  const _CustomAppbar({
    Key? key,
    required this.title,
    required this.img
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),
        background: FadeInImage(
          image: NetworkImage(img),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class _PosterTitle extends StatelessWidget{

  final String id;
  final String title;
  final String originalTitle;
  final double voteAvegare;
  final String img;

  const _PosterTitle({
    Key? key,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.voteAvegare,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(img),
                placeholder: const AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
                height: 150,
                width: size.width * 0.25,
              ),
            ),
          ),

          const SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  
                Text(title, style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2),
                Text(originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
          
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(voteAvegare.toString(), style: textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {

  final String description;

  const _OverView({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(
        description,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}