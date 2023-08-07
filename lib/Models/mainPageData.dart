import 'package:movies_app/Models/categoryModel.dart';

import 'movieModel.dart';

class MainPageData {
  final List<MovieModel>? movies;
  final int? page;
  final String? searchCategory;
  final String? searchText;

  MainPageData({this.movies, this.page, this.searchCategory, this.searchText});

  MainPageData.initial()
      : movies = [],
        page = 1,
        searchCategory = CategoryModel.popular,
        searchText = "";

  MainPageData copyWith({List<MovieModel>? newMovies, int? newPage,
      String? newSearchCategory, String? newSearchText}) {
    return MainPageData(
        movies: newMovies ?? movies,
        page: newPage ?? page,
        searchCategory: newSearchCategory ?? searchCategory,
        searchText: newSearchText ?? searchText);
  }
}
