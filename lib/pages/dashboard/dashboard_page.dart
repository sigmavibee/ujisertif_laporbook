import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/pages/dashboard/alllaporan_page.dart';
import 'package:lapor_book/pages/dashboard/mylaporan_page.dart';
import 'package:lapor_book/pages/profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardFull();
  }
}

class DashboardFull extends StatefulWidget {
  const DashboardFull({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardFull();
}

class _DashboardFull extends State<DashboardFull> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Akun akun = Akun(
    uid: '',
    docId: '',
    nama: '',
    noHp: '',
    email: '',
    role: '',
    picprofile: '',
  );

  void getAkun() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('akun')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          akun = Akun(
            uid: userData['uid'],
            nama: userData['nama'],
            noHp: userData['noHP'],
            email: userData['email'],
            role: userData['role'],
            docId: userData['docId'],
            picprofile: userData['picprofile'],
          );
        });
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text('Error fetching data: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;

  int _selectedIndex = 0;
  List<Widget> pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      AllLaporan(akun: akun),
      MyLaporan(akun: akun),
      Profile(akun: akun),
    ];
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.add,
            size: 35,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/add', arguments: {'akun': akun});
          },
        ),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Lapor Book',
            style: headerStyle(level: 2),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          selectedFontSize: 16,
          unselectedItemColor: Colors.grey[800],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Semua',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Laporan Saya',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : pages.elementAt(_selectedIndex));
  }
}
