// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:book_stash/service/database.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Add a Book',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter book title',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Price",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter price',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Author",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  hintText: 'Enter author name',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> bookInfoMap = {
                    "Title": titleController.text,
                    "Price": priceController.text,
                    "Author": authorController.text,
                    "Id": id,
                  };

                  await DatabaseHelper().addBookDetails(bookInfoMap, id).then((
                    value,
                  ) {
                    Message.show(message: 'Book has been added');
                    titleController.clear();
                    priceController.clear();
                    authorController.clear();
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Add Book',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
