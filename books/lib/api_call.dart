import 'dart:convert';

import 'package:http/http.dart' as http;

class Users {
  String etag;
  // String username;
  // String email;
  Users({
    required this.etag,
    // required this.username,
    // required this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        etag: json["etag"],
        // username: json["username"],
        // email: json["email"],
      );
}

Future<List<Users>> getUsers() async {
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/books/v1/volumes?q=Tolkien&maxResults=20&startIndex=20&orderBy=relevance'),
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Users> users = [];
    for (var u in jsonResponse) {
      Users user =
          Users(etag: u['etag']);
      users.add(user);
    }
    return users;
  } else {
    throw Exception('Failed to load post');
  }
}
