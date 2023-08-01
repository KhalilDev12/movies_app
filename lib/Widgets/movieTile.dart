import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../Models/movieModel.dart';

class MovieTile extends StatelessWidget {
  final MovieModel movie;
  final double height, width;

  MovieTile(
      {Key? key,
      required this.movie,
      required this.height,
      required this.width})
      : super(key: key);

  final GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie.posterURL()),
          _movieInfoWidget(),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String posterUrl) {
    return Container(
      height: height,
      width: width * 0.26,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(posterUrl),
        ),
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: width * 0.72,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.5,
                  child: Text(movie.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                ),
                Text(
                  movie.rating.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
            Container(
              padding:
                  EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
              child: Text(
                  "${movie.language.toUpperCase()} | R: ${movie.isAdult} | ${movie.releaseDate}",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            Container(
              child: Text(
                movie.description,
                maxLines: 9,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            )
          ]),
    );
  }
}
