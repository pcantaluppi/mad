// home.dart
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/common/page_header.dart';
import '/components/common/page_heading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            });
            return Container(); // Return empty container to handle frame callback
          }
          return _HomePageStateful();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _HomePageStateful extends StatefulWidget {
  @override
  __HomePageStatefulState createState() => __HomePageStatefulState();
}

class __HomePageStatefulState extends State<_HomePageStateful> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = FirebaseFirestore.instance.collection('tasks').snapshots();
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _tasksStream =
            FirebaseFirestore.instance.collection('tasks').snapshots();
      });
    } else {
      String searchText = _searchController.text;
      String endString = searchText.substring(0, searchText.length - 1) +
          String.fromCharCode(searchText.codeUnitAt(searchText.length - 1) + 1);
      setState(() {
        _tasksStream = FirebaseFirestore.instance
            .collection('tasks')
            .where('title', isGreaterThanOrEqualTo: searchText)
            .where('title', isLessThan: endString)
            .snapshots();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Search trains",
                  hintText: "Enter train number",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const PageHeading(title: 'Contoso Logistics'),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transports',
                              style: TextStyle(fontSize: 24),
                            ),
                            _buildTaskList(), // Firestore data display
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something bad happened');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['title']),
            );
          }).toList(),
        );
      },
    );
  }
}
