import 'package:spyrift/services/opgg.dart';
import 'package:spyrift/util.dart';

class OpggRepository {
  OpggRepository({required this.opgg});

  final Opgg opgg;

  Future<Result<String>> fetchAccountRanking({required String url}) async {
    try {
      final String ranking = await opgg.fetchAccountRanking(url: url);
      return Result<String>.ok(ranking);
    } on Exception catch (e) {
      return Result<String>.error(e);
    }
  }
}
