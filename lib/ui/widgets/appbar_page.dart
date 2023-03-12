import 'package:flutter/material.dart';

class AppbarPage extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  bool? isLeading;

  @override
  final Size preferredSize;

  AppbarPage({
    Key? key,
    this.title,
    this.isLeading = true
  })  : preferredSize = const Size.fromHeight(60.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black87),
      leading: isLeading! ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context,true),
      ) : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      title: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              title!,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          )),
    );
  }
}
