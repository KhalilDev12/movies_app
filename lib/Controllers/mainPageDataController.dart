import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/mainPageData.dart';
import 'package:movies_app/Models/movieModel.dart';
import 'package:movies_app/Services/moviesService.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getPopularMovies(); // Get Popular Movies
  }

  final MoviesService _moviesService = GetIt.instance.get<MoviesService>();

  Future<void> getPopularMovies() async {
    try {
      List<MovieModel> _movies =
          await _moviesService.getPopularMovies(page: state.page);
      state = state.copyWith(
          newMovies: [...?state.movies, ..._movies], newPage: state.page! + 1);
    } catch (e) {}
  }
}
