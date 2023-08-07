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

  // Function to get Popular Movies
  Future<List<MovieModel>> getPopularMovies({int? page}) async {
    // get response from url
    Response response =
    await http.get("/movie/popular", query: {'page': page});
    if (response.statusCode == 200) {
      Map data = response.data;
      // extract movies from data
      List<MovieModel> popularMovies =
      data["results"].map<MovieModel>((movieData) {
        return MovieModel.fromJson(movieData);
      }).toList();
      return popularMovies;
    } else {
      throw Expando("Couldn\'t load popular movies");
    }
  }
}
