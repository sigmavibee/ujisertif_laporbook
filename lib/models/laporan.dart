class Laporan {
  final String uid;
  final String docId;

  final String judul;
  final String instansi;
  String? deskripsi;
  String? gambar;
  final String nama;
  final String status;
  final DateTime tanggal;
  final String maps;
  List<String>? komentar;
  List<dynamic>? likes;

  Laporan({
    required this.uid,
    required this.docId,
    required this.judul,
    required this.instansi,
    this.deskripsi,
    this.gambar,
    required this.nama,
    required this.status,
    required this.tanggal,
    required this.maps,
    this.komentar,
    this.likes,
  });
}

class Komentar {
  final String nama;
  final String isi;

  Komentar({
    required this.nama,
    required this.isi,
  });
}

enum Status {
  posted,
  procress,
  done,
}
