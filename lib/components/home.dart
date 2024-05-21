// hone.dart
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_tracker/components/detail.dart';
import 'package:train_tracker/components/login.dart';
import 'package:train_tracker/components/common/page_header.dart';
import 'package:train_tracker/components/common/page_heading.dart';
import 'package:train_tracker/state/user_provider.dart';
import 'package:train_tracker/state/models/user_model.dart';

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
  late Stream<QuerySnapshot> _transportsStream;
  final Logger logger = Logger();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _transportsStream =
        FirebaseFirestore.instance.collection('transports').snapshots();
    _searchController.addListener(_filterTransports);
  }

  void _logHomePageVisit() {
    analytics.logEvent(name: 'home_page_visit', parameters: {
      'visit_time': DateTime.now().toIso8601String(),
    }).then((_) {
      logger.i('Successful login logged.');
    }).catchError((error) {
      logger.e('Failed to log successful login: $error');
    });
  }

  void _filterTransports() {
    setState(() {
      _transportsStream =
          FirebaseFirestore.instance.collection('transports').snapshots();
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
    UserModel? user = Provider.of<UserProvider>(context).user;
    logger.i('Image: ${user?.logo}');
    _logHomePageVisit();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffEEF1F3),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const PageHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Image.network(
                        user?.logo ?? '',
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // logger.e(
                          //     'Error loading image: ${jsonEncode(exception)}');
                          return const Text('Error loading image');
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            final progress =
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null;
                            logger.i('Loading progress: $progress');
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const PageHeading(title: 'Transports'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search trains",
                    hintText: "Enter train number",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTaskList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    //final logger = Logger();

    return StreamBuilder<QuerySnapshot>(
      stream: _transportsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((document) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          if (data == null) return false;

          String title = data['title'] ?? "";
          return title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("No transports found."));
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
            //logger.i('Item: $data');
            return ListTile(
              title: Text(data['title'] ?? "No title"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(trainId: data['id']),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
