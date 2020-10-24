import 'package:MyTask/Widgets/lazyListSingle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LazyList extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LazyList> {

  //data members
  int pageNo = 1;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List albums = List();



// member Functions
  void _fetchData() async {
    String apiUrl =
        "https://xpence-test.azurewebsites.net/api/data/v1/paged-list?page=$pageNo&pageSize=10";
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        apiUrl,
      );
      if (response.statusCode == 200) {
        List albumList = List();
        Map resultmap;
        var resultBody;

        pageNo++; // incrementing page

        resultmap = jsonDecode(response.body);
        resultBody = resultmap['Results'];
        for (int i = 0; i < resultBody.length; i++) {
          setState(() {
            albumList.add(resultBody[i]);
          });
        }
        setState(() {
          isLoading = false;
          albums.addAll(albumList);
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    this._fetchData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: albums.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == albums.length) {
          return _buildProgressIndicator();
        } else {
          return LazyListSingle(
            id: albums[index]['Id'],
            name: albums[index]['Name'],
          );
        }
      },
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('List with pagination')),
      body: Column(
        children: [
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
