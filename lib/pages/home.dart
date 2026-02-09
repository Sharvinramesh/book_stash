// ignore_for_file: use_build_context_synchronously

import 'package:book_stash/pages/books.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/database.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  Stream? bookStream;

  dynamic getInfoInit() async {
    bookStream = await DatabaseHelper().getAllBooksInfo();
    setState(() {});
  }

  @override
  void initState() {
    getInfoInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Book Stash',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, top: 25, right: 10),
        child: Column(children: [Expanded(child: allBooksInfo())]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Books()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget allBooksInfo() {
    return StreamBuilder(
      stream: bookStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.book_rounded,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      titleController.text =
                                          documentSnapshot['Title'];
                                      priceController.text =
                                          documentSnapshot['Price'];
                                      authorController.text =
                                          documentSnapshot['Author'];
                                      editBook(documentSnapshot["Id"]);
                                    },
                                    child: const Icon(
                                      Icons.edit_document,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDeleteConfirmationDialog(
                                        context,
                                        documentSnapshot['Id'],
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Title: ${documentSnapshot["Title"]}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Price: ₹${documentSnapshot["Price"]}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Author: ${documentSnapshot["Author"]}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  Future editBook(String id) {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit a book',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          size: 35,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    height: 10,
                    color: Colors.deepPurple,
                    thickness: 5,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Price",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Author",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: authorController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              Map<String, dynamic> updateDetails = {
                                'Title': titleController.text,
                                'Price': priceController.text,
                                'Author': authorController.text,
                                'Id': id,
                              };
                              await DatabaseHelper()
                                  .updateBook(id, updateDetails)
                                  .then((value) {
                                    Message.show(
                                      message: 'Book Updated Successfully',
                                    );
                                    Navigator.pop(context);
                                  });
                            },
                            child: const Text('Update'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation '),
          content: const Text("Are you sure want to delete this book?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper().deleteBook(id);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure want to Logout?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await AuthServiceHelper.logout();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Text("Yes"),
              ),
            ],
          ),
    );
  }
}
