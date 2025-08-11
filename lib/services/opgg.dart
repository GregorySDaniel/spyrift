import 'package:http/http.dart';
import 'package:spyrift/services/web_interface.dart';

class Opgg implements WebInterface {
  @override
  Future<String> fetchAccountRanking({required String link}) async {
    final Uri uri = Uri.parse(link);
    final Response response = await get(uri);
    final String body = response.body;
    final RegExp regex = RegExp(
      r'<meta name="description" content="(.*?)"',
      caseSensitive: false,
    );
    final RegExpMatch? match = regex.firstMatch(body);

    if (match != null) {
      final String ranking = match.group(1)!.split('/')[1];
      return ranking;
    }

    throw Exception('Not found');
  }
}
