import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconButton? leading;
  final IconButton? actions;
  final StreamBuilder<QuerySnapshot<Map<String, dynamic>>>?
      actionsStreamBuilder;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.leading,
      this.actions,
      this.actionsStreamBuilder});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(360),
          bottomRight: Radius.circular(360),
        ),
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          foregroundColor: Theme.of(context).primaryColor,
          leading: leading != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 30), child: leading)
              : Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
          actions: (actionsStreamBuilder != null || actions != null)
              ? [
                  Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: actionsStreamBuilder ?? actions),
                ]
              : [],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
