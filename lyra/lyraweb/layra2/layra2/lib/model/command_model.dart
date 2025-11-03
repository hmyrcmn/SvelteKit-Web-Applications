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

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      komut: json['komut'],
      konum: json['konum'],
      hedef: json['hedef'],
      eylem: json['eylem'],
      tarih: json['tarih'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'komut': komut,
      'konum': konum,
      'hedef': hedef,
      'eylem': eylem,
      'tarih': tarih,
    };
  }
}
