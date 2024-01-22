import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final Akun akun;
  const Profile({super.key, required this.akun});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  XFile? file;
  ImagePicker picker = ImagePicker();

  void keluar(BuildContext context) async {
    // keluar
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  Future<dynamic> updatePic(BuildContext context) {
    return showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: const Text('Pilih sumber '),
            actions: [
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.photo_library),
              ),
            ],
          );
        });
  }

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/noimg.png', width: 180, height: 180);
    } else {
      return Image.file(File(file!.path), width: 180, height: 180);
    }
  }

  void editProfileField(String fieldName) async {
    String? newValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(fieldName),
      ),
    );

    if (newValue != null && newValue.isNotEmpty) {
      // Update data in Firestore
      await FirebaseFirestore.instance
          .collection('users') // Change 'users' to your collection name
          .doc(widget.akun.uid) // Assume uid is the document ID
          .update({
        fieldName.toLowerCase(): newValue,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  updatePic(context);
                },
                child: ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? Center(child: imagePreview())
                        : Image.network(
                            widget.akun.picprofile == ''
                                ? 'assets/noimgprof.png'
                                : widget.akun.picprofile,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                _isLoading =
                                    false; // Set loading state to false when image is loaded
                                return child;
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              buildEditableProfileField(
                'Nama',
                widget.akun.nama,
                () => editProfileField('Nama'),
              ),
              buildEditableProfileField(
                'Role',
                widget.akun.role,
                () => editProfileField('Role'),
              ),
              buildEditableProfileField(
                'No HP',
                widget.akun.noHp,
                () => editProfileField('No HP'),
              ),
              buildEditableProfileField(
                'Email',
                widget.akun.email,
                () => editProfileField('Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: FilledButton(
                  style: buttonStyle,
                  onPressed: () {
                    //update(context);
                  },
                  child: const Text('Ubah',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: FilledButton(
                  style: buttonStyle,
                  onPressed: () {
                    keluar(context);
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildEditableProfileField(
    String label, String value, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: grey2Color),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}

class EditProfileScreen extends StatefulWidget {
  final String fieldName;

  EditProfileScreen(this.fieldName);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fieldName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter new ${widget.fieldName}'),
            TextField(
              controller: _controller,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
