import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

@override
void search() {}

class _MyAppState extends State<MyApp> {
  List<dynamic> books = [];
  List<dynamic> booksSearch = [];
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    fetchBooks();
    List<bool> _isFavorited = List.filled(books.length, false);
    return MaterialApp(
        home: Scaffold(
      appBar: EasySearchBar(
        title: const Text('Arama'),
        onSearch: (value) {
          setState(() {
            searchValue = value;
          });
        },
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
            if (searchValue.isEmpty) {
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
                subtitle: Text(
                  descriptions,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                trailing:               Column(
                children: [
                    InkWell(
                    onTap: () {
                                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewScreen(book: books[index]),
                      ),
                    );
                    },
                    child: Icon(Icons.arrow_right),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _isFavorited[index] = !_isFavorited[index]);
                    },
                    child: Icon(Icons.favorite),
                  ),
                ],
              ),
                
              );
            } else if (titles.toLowerCase().contains(searchValue)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });

              return ListTile(
                  title: Text(
                    titles,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 194, 0, 0),
                    ),
                  ),
                  subtitle: Text(
                    descriptions,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    
                  ),
                  
                  );
            } else {
              return Container();
            }
          }),
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
        book['volumeInfo']['title'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 187, 6, 6),
        ),
      )),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
        child: new Text(
          book['volumeInfo']['description'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(0, 0, 0, 1),
            letterSpacing: 0.5,
            
          ),
        ),
      ),
    );
  }
}
