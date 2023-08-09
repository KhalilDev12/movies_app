import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/categoryModel.dart';
import 'package:movies_app/Models/mainPageData.dart';
import 'package:movies_app/Models/movieModel.dart';
import 'package:movies_app/Services/moviesService.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies(); // Get Popular Movies
  }

  final MoviesService _moviesService = GetIt.instance.get<MoviesService>();

  Future<void> getMovies() async {
    try {
      String category = state.searchCategory
          .toString()
          .toLowerCase(); // get Selected Category
      List<MovieModel> movies = [];
      if (state.searchText!.isEmpty) {
        if (state.searchCategory != CategoryModel.none) {
          movies = await _moviesService.getMovies(
              page: state.page, category: category);
        } else {
          movies = [];
        }
      } else {
        // Perform Text Search
        movies = await _moviesService.searchMovies(state.searchText!,page: state.page);
      }
      state = state.copyWith(
          newMovies: [...?state.movies, ...movies], newPage: state.page! + 1);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String newCategory) {
    try {
      state = state.copyWith(
          newMovies: [],
          newPage: 1,
          newSearchCategory: newCategory,
          newSearchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String searchText) {
    try {
      state = state.copyWith(
          newMovies: [],
          newPage: 1,
          newSearchCategory: CategoryModel.none,
          newSearchText: searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }

}
