import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> books = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Kütüphane'),
        centerTitle: true,
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: const Color.fromARGB(255, 107, 101, 101),
              ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            final titles = book['volumeInfo']['title'];
            final descriptions = book['volumeInfo']['description'];
            final profileImage = book['volumeInfo']['imageLinks']['thumbnail'];
            return ListTile(
                leading: SizedBox(
                  width: 50,
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl: profileImage,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(
                  titles,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 194, 0, 0),
                  ),
                ),
                // onTap:(){print(book['volumeInfo']['imageLinks']['thumbnail']);},
                onTap: () {
                  print(book['volumeInfo']['imageLinks']['thumbnail']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewScreen(book : books[index]),
                    ),
                  );
                },
                //  onTap: () {
                //    Navigator.push(
                //     context,
                //      MaterialPageRoute(builder: (context) => YourNewPage(name:data[index]["name"],image:data[index]["image"]),),
                //    );
                //  },
                subtitle: Text(
                  descriptions,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(onPressed: fetchBooks),
    ));
  }

  void fetchBooks() async {
    const url =
        "https://www.googleapis.com/books/v1/volumes?q=Tolkien&maxResults=20&startIndex=20&orderBy=relevance";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      books = json['items'];
    });
  }
}

class NewScreen extends StatelessWidget {
  @override
  const NewScreen({super.key, required this.book});
  final dynamic book;
  
  Widget build(BuildContext context) {
    print("bbbbbbbbbbbbbbbbbbbbbbbbbb");
    print(book['id']);
    // final id=book['id'];
    // final sss = book['volumeInfo']['title'];
    return Scaffold(
      
      appBar: AppBar(title: Text(book['volumeInfo']['title']                  ,
      style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 187, 6, 6),
                  ),)),
    body: new Center(
      child: new Text(
        book['volumeInfo']['description']
      ),
    ),
    );
  }
}
