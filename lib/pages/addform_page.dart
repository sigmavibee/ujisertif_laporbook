import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/validators.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../components/input_widget.dart';
import 'package:lapor_book/components/vars.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage({super.key});

  @override
  State<AddFormPage> createState() => AddFormState();
}

class AddFormState extends State<AddFormPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Tambah Laporan', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Form(
                      child: Container(
                    margin: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                          'Judul Laporan',
                          TextFormField(
                            onChanged: (value) => {},
                            validator: noEmptyValidator,
                            decoration: customInputDecoration('Judul Laporan'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_camera),
                                Text(
                                  'Foto Pendukung',
                                  style: headerStyle(level: 3),
                                )
                              ],
                            ),
                          ),
                        ),
                        InputLayout(
                            'Instansi',
                            DropdownButtonFormField<String>(
                              decoration: customInputDecoration('Instansi'),
                              items: [],
                              onChanged: (value) => {},
                            )),
                        InputLayout(
                            'Deskripsi Laporan',
                            TextFormField(
                              onChanged: (value) => {},
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua laporan anda disini'),
                            )),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: () {},
                              child: Text(
                                'Kirim Laporan',
                                style: headerStyle(level: 3, dark: false),
                              )),
                        )
                      ],
                    ),
                  )),
                )),
    );
  }
}
