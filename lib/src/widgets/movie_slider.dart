import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    Key? key, 
    required this.movies,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();
  

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        widget.onNextPage();
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if( widget.title != null)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

          const SizedBox( height: 10),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: ( _, int index) => _MoviePoster( movie: widget.movies[index] )
              ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;

  const _MoviePoster({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {    

    movie.heroId = 'slider-${movie.id}}';

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [

          GestureDetector(
            onTap: (() => Navigator.pushNamed(context, 'details', arguments: movie)),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/img/loading.gif'),
                  image: NetworkImage( movie.FullPosterImg ),
                  fit: BoxFit.cover,
                  height: 190,
                  width: 130,
                ),
              ),
            ),
          ),

          const SizedBox( height: 5),

          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )

        ],
      ),
    );
  }
}
