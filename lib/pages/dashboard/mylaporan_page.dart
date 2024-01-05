import 'package:flutter/material.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_book/components/list_item.dart';
import 'package:lapor_book/models/laporan.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLaporan extends StatefulWidget {
  final Akun akun;
  const MyLaporan({super.key, required this.akun});

  @override
  State<MyLaporan> createState() => _MyLaporanState();
}

class _MyLaporanState extends State<MyLaporan> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Laporan> listLaporan = [];

  void getTransaksi() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('laporan')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      setState(() {
        listLaporan.clear();
        for (var documents in querySnapshot.docs) {
          List<dynamic>? komentarData = documents.data()['komentar'];

          List<String>? listKomentar = komentarData?.map((komentar) {
            return komentar.toString(); // Mengasumsikan komentar adalah String
          }).toList();

          listLaporan.add(
            Laporan(
              uid: documents.data()['uid'],
              docId: documents.data()['docId'],
              judul: documents.data()['judul'],
              instansi: documents.data()['instansi'],
              deskripsi: documents.data()['deskripsi'],
              nama: documents.data()['nama'],
              status: documents.data()['status'],
              gambar: documents.data()['gambar'],
              tanggal: documents['tanggal'].toDate(),
              maps: documents.data()['maps'],
              komentar: listKomentar,
            ),
          );
        }
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTransaksi();
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 1.219),
            itemCount: listLaporan.length,
            itemBuilder: (context, index) {
              return ListItem(
                laporan: listLaporan[index],
                akun: widget.akun,
                isLaporanku: true,
              );
            }),
      ),
    );
  }
}
