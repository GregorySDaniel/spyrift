class AccountModel {
  final int id;
  final int customerId;
  final int? decayGames;
  final String? link;
  final String? nick;
  final String? tag;
  final String? ranking;

  AccountModel({
    required this.id,
    required this.customerId,
    this.ranking,
    this.tag,
    this.decayGames,
    this.link,
    this.nick,
  });
}
