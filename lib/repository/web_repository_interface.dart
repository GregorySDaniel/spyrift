import 'package:spyrift/util.dart';

abstract class WebRepositoryInterface {
  Future<Result<String>> fetchAccountRanking({required String link});
}
