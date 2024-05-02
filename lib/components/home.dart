import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_tracker/components/login.dart';
import '/components/common/page_header.dart';
import '/components/common/page_heading.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
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
  late Stream<QuerySnapshot> _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = FirebaseFirestore.instance.collection('tasks').snapshots();
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    setState(() {
      _tasksStream = FirebaseFirestore.instance.collection('tasks').snapshots();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(context);
  }

  Widget _buildHomePage(BuildContext context) {
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
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '> Transports',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            _buildTaskList(),
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
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((document) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          if (data == null) return false; // Ensure data is not null

          String title = data['title'] ?? ""; // Use null-aware access
          return title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("No tasks found."));
        }

        return ListView.separated(
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey),
          itemCount: filteredDocs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                filteredDocs[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(
                  data['title'] ?? "No title"), // Handle potential null title
            );
          },
        );
      },
    );
  }
}
