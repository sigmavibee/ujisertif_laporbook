import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
  const ListItem(
      {super.key,
      required this.laporan,
      required this.akun,
      required this.isLaporanku});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void deleteLaporan() async {
    try {
      await _firestore.collection('laporan').doc(widget.laporan.docId).delete();
      // hapus gambar dari storage
      if (widget.laporan.gambar != '') {
        await _storage.refFromURL(widget.laporan.gambar!).delete();
      }
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: {
              'laporan': widget.laporan,
              'akun': widget.akun,
            });
          },
          onLongPress: () {
            if (widget.isLaporanku) {
              showDialog(
                  context: context,
                  builder: (BuildContext) {
                    return AlertDialog(
                      title: Text('Hapus ${widget.laporan.judul}?'),
                      content: Text(
                          'Apakah anda yakin ingin menghapus laporan ${widget.laporan.judul}?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteLaporan();
                          },
                          child: const Text('Hapus'),
                        )
                      ],
                    );
                  });
            }
          },
          child: Column(
            children: [
              widget.laporan.gambar != ''
                  ? Image.network(
                      widget.laporan.gambar!,
                      width: 130,
                      height: 130,
                    )
                  : Image.asset(
                      'assets/noimg.png',
                      width: 130,
                      height: 130,
                    ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(width: 2))),
                child: Text(
                  widget.laporan.judul,
                  style: headerStyle(level: 5),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: widget.laporan.status == 'Posted'
                              ? warningColor
                              : widget.laporan.status == 'On Process'
                                  ? Colors.green
                                  : widget.laporan.status == 'Done'
                                      ? Colors.blue
                                      : dangerColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border: const Border.symmetric(
                              vertical: BorderSide(width: 1))),
                      alignment: Alignment.center,
                      child: Text(
                        widget.laporan.status,
                        style: headerStyle(level: 5, dark: false),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: warningColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border: const Border.symmetric(
                              vertical: BorderSide(width: 1))),
                      alignment: Alignment.center,
                      child: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget.laporan.tanggal),
                          style: headerStyle(level: 5, dark: false)),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
