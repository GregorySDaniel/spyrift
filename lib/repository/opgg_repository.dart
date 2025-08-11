import 'package:spyrift/repository/web_repository_interface.dart';
import 'package:spyrift/services/web_interface.dart';
import 'package:spyrift/util.dart';

class OpggRepository implements WebRepositoryInterface {
  OpggRepository({required this.webService});

  final WebInterface webService;

  @override
  Future<Result<String>> fetchAccountRanking({required String link}) async {
    try {
      final String ranking = await webService.fetchAccountRanking(link: link);
      return Result<String>.ok(ranking);
    } on Exception catch (e) {
      return Result<String>.error(e);
    }
  }
}
