class AccountModel {
  final int? id;
  final int? customerId;
  final int? decayGames;
  final String? link;
  final String? nick;
  final String? tag;
  final String? ranking;

  AccountModel({
    this.id,
    this.customerId,
    this.ranking,
    this.tag,
    this.decayGames,
    this.link,
    this.nick,
  });

  AccountModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      link = json['link'],
      decayGames = json['decay_games'],
      customerId = json['customer_id'],
      ranking = json['ranking'],
      nick = json['nick'],
      tag = json['tag'];
}
