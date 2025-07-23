class AccountModel {
  AccountModel({
    this.id,
    this.customerId,
    this.ranking,
    this.tag,
    this.decayGames,
    this.region,
    this.link,
    this.nick,
  });

  AccountModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      link = json['link'] as String?,
      decayGames = json['decay_games'] as int?,
      customerId = json['customer_id'] as int?,
      ranking = json['ranking'] as String?,
      nick = json['nick'] as String?,
      region = json['region'] as String?,
      tag = json['tag'] as String?;

  final int? id;
  final int? customerId;
  final int? decayGames;
  final String? link;
  final String? nick;
  final String? tag;
  final String? ranking;
  final String? region;
}
