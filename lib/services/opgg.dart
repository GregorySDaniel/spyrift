import 'package:http/http.dart';

class Opgg {
  Future<String> fetchAccountRanking({required String url}) async {
    final Uri uri = Uri.parse(url);
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

    return 'Not found';
  }
}
