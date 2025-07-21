class AccountModel {
  final int id;
  final int customerId;
  final int? decayGames;
  final String link;
  final String nick;
  final String tag;
  final String ranking;

  AccountModel({
    required this.ranking,
    required this.id,
    required this.customerId,
    required this.tag,
    this.decayGames,
    required this.link,
    required this.nick,
  });
}
