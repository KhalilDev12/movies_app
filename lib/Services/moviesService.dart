import 'package:get_it/get_it.dart';
import 'package:movies_app/Services/httpService.dart';

class MoviesService {
  final getIt = GetIt.instance;
  late HttpService http;

  MoviesService() {
    http = getIt.get<HttpService>();
  }
}
