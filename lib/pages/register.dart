import 'package:flutter/material.dart';
import 'package:lapor_book/components/input_widget.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? nama;
  String? email;
  String? noHP;

  final TextEditingController _password = TextEditingController();

  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void register() async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference akunCollection = _db.collection('akun');

      final password = _password.text;
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password);

      final docId = akunCollection.doc().id;
      await akunCollection.doc(docId).set({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'email': email,
        'noHP': noHP,
        'docId': docId,
        'role': 'user'
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text('Daftar', style: headerStyle(level: 1)),
                    const Text(
                      'Buat akun baru untuk melanjutkan',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // di sini nanti komponen inputnya
                              InputLayout(
                                  'Nama',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            nama = value;
                                          }),
                                      validator: noEmptyValidator,
                                      decoration: customInputDecoration(
                                          "Nama Lengkap"))),
                              InputLayout(
                                  'Email',
                                  TextFormField(
                                    onChanged: (String value) => setState(() {
                                      email = value;
                                    }),
                                    validator: noEmptyValidator,
                                    decoration: customInputDecoration(
                                        'email@email.com'),
                                  )),
                              InputLayout(
                                'Nomor Handphone',
                                TextFormField(
                                  onChanged: (String value) => setState(() {
                                    noHP = value;
                                  }),
                                  validator: noEmptyValidator,
                                  decoration:
                                      customInputDecoration('08xxxxxxx'),
                                ),
                              ),
                              InputLayout(
                                  'Password',
                                  TextFormField(
                                    controller: _password,
                                    validator: noEmptyValidator,
                                    obscureText: true,
                                    decoration: customInputDecoration(
                                        'Masukkan password'),
                                  )),
                              InputLayout(
                                'Konfirmasi Password',
                                TextFormField(
                                  validator: (value) =>
                                      passConfirmationValidator(
                                          value, _password),
                                  obscureText: true,
                                  decoration: customInputDecoration(
                                      'Masukkan password'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: FilledButton(
                                    style: buttonStyle,
                                    child: Text('Daftar',
                                        style: headerStyle(level: 2)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                      }
                                    }),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah punya akun? '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text('Masuk di sini',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
