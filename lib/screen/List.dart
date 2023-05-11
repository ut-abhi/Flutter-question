import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'Student.dart';
import 'dart:convert';

class Listofstudents extends StatefulWidget {
  @override
  State<Listofstudents> createState() => _ListofstudentsState();
}

class _ListofstudentsState extends State<Listofstudents> {
  List<Student> students = [];
  bool isSearching = false;
  String searchName = '';
  List<String> names = [];
  getRnu() async {
    var response = await Dio().get(
        'https://1qy9d2uuyg.execute-api.ap-northeast-1.amazonaws.com/default/Students-API');
    return response.data;
  }

  @override
  void initState() {
    getRnu().then((data) {
      setState(() {
        var decoded_data = json.decode(data);
        for (var item in decoded_data) {
          students.add(Student.fromMap(item));
          names.add(Student.fromMap(item).name.toLowerCase());
        }
      });
    });
    super.initState();
  }

  void _filterNames(value) {
    setState(() {
      searchName = value;
    });
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    print('build function has been called');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: !isSearching
            ? Text('List of students')
            : TextField(
          onChanged: (value) {
            _filterNames(value);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.white),
              hintText: "Search the student details",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  this.isSearching = !this.isSearching;
                  searchName = '';
                });
              })
              : IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  this.isSearching = !this.isSearching;
                });
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: students.length > 0 && searchName == ''
            ? ListView.builder(
            itemCount: students.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roll No. ${students[index].rollNo}',
                        style: TextStyle(fontSize: 19),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Name. ${students[index].name}',
                        style: TextStyle(fontSize: 19),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'College. ${students[index].college}',
                        style: TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                ),
              );
            })
            : searchName != ''
            ? names.contains(searchName.toLowerCase())
            ? Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Roll No. ${students.firstWhere((element) => element.name.toLowerCase() == searchName.toLowerCase()).rollNo}',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Name. ${students.firstWhere((element) => element.name.toLowerCase() == searchName.toLowerCase()).name}',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'College. ${students.firstWhere((element) => element.name.toLowerCase() == searchName.toLowerCase()).college}',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            : const Center(
          child: Text('No Record found'),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
