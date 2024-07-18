class Survey {
  final int idSurvei;
  final int idAccount;
  final String namaSurvei;
  final String tanggalPublish;
  final String updatePublish;
  final String createAt;

  Survey({
    required this.idSurvei,
    required this.idAccount,
    required this.namaSurvei,
    required this.tanggalPublish,
    required this.updatePublish,
    required this.createAt,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      idSurvei: json['id_survei'],
      idAccount: json['id_account'],
      namaSurvei: json['nama_survei'],
      tanggalPublish: json['tanggal_publish'],
      updatePublish: json['update_publish'],
      createAt: json['create_at'],
    );
  }
}