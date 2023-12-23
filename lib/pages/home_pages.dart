import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../helper/sqflite_helper.dart';
import '../model/doctor_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollConroller = ScrollController();
  bool isLoading = false;
  List<Data> posts = [];
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollConroller.addListener(_scrool);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView.builder(
            controller: scrollConroller,
            itemCount: isLoading ? posts.length + 1 : posts.length,
            itemBuilder: (context, index) {
              if (index < posts.length) {
                final title = posts[index].name;
                return ListTile(
                  title: Text(index.toString()),
                  leading: Text("$title"),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Future<void> fetchData() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer 141|e81hoIXtG52xjpr5ujEZhZhOZcN4m1qoqtqoZCZE"
    };
    final url = "http://skinvd.itmapi.com/api/doctor/list?page=$page";
    print("url$url");
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // print(response.body);
      final json = jsonDecode(response.body);
      DoctorModel doctorModel = DoctorModel.fromJson(json);
      setState(() {
        // posts=json;
        for (Data data in doctorModel.data!) {
          posts.add(data);
          DoctorHelper.dbHelper.insertNewRecipe(data);
        }
      });
    } else {
      print("Unexpedte response");
    }
  }

  Future<void> _scrool() async {
    if (isLoading) return;
    if (scrollConroller.position.pixels ==
        scrollConroller.position.maxScrollExtent) {
      print("call");
      setState(() {
        isLoading = true;
      });
      page = page + 1;
      await fetchData();
      setState(() {
        isLoading = false;
      });
    }
    // else{
    //   print("dont call");
    // }
  }
}
