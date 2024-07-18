class Soal {
  final int id_soal;
  final int id_account;
  final int id_survey;
  final String soal;
  final String a;
  final String b;
  final String c;
  final String d;

  Soal({
    required this.id_soal,
    required this.id_account,
    required this.id_survey,
    required this.soal,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  factory Soal.fromJson(Map<String, dynamic> json) {
    return Soal(
      id_soal: json['id_soal'],
      id_account: json['id_account'],
      id_survey: json['id_survei'],  // Perbaikan dari 'id_survei' ke 'id_survey'
      soal: json['soal'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      d: json['d'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_soal': id_soal,
      'id_account': id_account,
      'id_survey': id_survey,
      'soal': soal,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
    };
  }
}
