class Command {
  final String komut;
  final String konum;
  final String hedef;
  final String eylem;
  final String tarih;

  Command({
    required this.komut,
    required this.konum,
    required this.hedef,
    required this.eylem,
    required this.tarih,
  });

  Map<String, dynamic> toJson() {
    return {
      'komut': komut,
      'konum': konum,
      'hedef': hedef,
      'eylem': eylem,
      'tarih': tarih,
    };
  }

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      komut: json['komut'] as String,
      konum: json['konum'] as String,
      hedef: json['hedef'] as String,
      eylem: json['eylem'] as String,
      tarih: json['tarih'] as String,
    );
  }
}
