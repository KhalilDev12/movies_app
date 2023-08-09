import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/movieModel.dart';
import 'package:movies_app/Services/httpService.dart';

class MoviesService {
  final getIt = GetIt.instance;
  late HttpService http;

  MoviesService() {
    http = getIt.get<HttpService>();
  }

  // Function to get Movies
  Future<List<MovieModel>> getMovies(
      {int? page, required String category}) async {
    // get response from url
    Response response =
        await http.get("/movie/$category", query: {'page': page});
    if (response.statusCode == 200) {
      Map data = response.data;
      // extract movies from data
      List<MovieModel> popularMovies =
          data["results"].map<MovieModel>((movieData) {
        return MovieModel.fromJson(movieData);
      }).toList();
      return popularMovies;
    } else {
      throw Expando("Couldn\'t load $category movies");
    }
  }


  // Function to search Movies
  Future<List<MovieModel>> searchMovies(String searchTerm, {int? page}) async {
    // get response from url
    Response response = await http.get("/search/movie", query: {
      'query': searchTerm,
      'page': page,
    });
    if (response.statusCode == 200) {
      Map data = response.data;
      // extract movies from data
      List<MovieModel> movies =
          data["results"].map<MovieModel>((movieData) {
        return MovieModel.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Expando("Couldn\'t perform movie search");
    }
  }
}
